/*
 * Copyright (c) 2001-2003 Swedish Institute of Computer Science.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 * This file is part of the lwIP TCP/IP stack.
 *
 * Author: Adam Dunkels <adam@sics.se>
 *
 */

/* This file is modified from the original version (httpd.c) as shipped with
 * lwIP version 1.3.2. Changes have been made to allow support for a
 * rudimentary server-side-include facility which will replace tags of the form
 * <!--#tag--> in any file whose extension is .shtml, .shtm or .ssi with
 * strings provided by an include handler whose pointer is provided to the
 * module via function http_set_ssi_handler(). Additionally, a simple common
 * gateway interface (CGI) handling mechanism has been added to allow clients
 * to hook functions to particular request URIs.
 *
 * To enable SSI support, define label INCLUDE_HTTPD_SSI in lwipopts.h.
 * To enable CGI support, define label INCLUDE_HTTPD_CGI in lwipopts.h.
 *
 * By default, the server assumes that HTTP headers are already present in
 * each file stored in the file system.  By defining DYNAMIC_HTTP_HEADERS in
 * lwipopts.h, this behavior can be changed such that the server inserts the
 * headers automatically based on the extension of the file being served.  If
 * this mode is used, be careful to ensure that the file system image used
 * does not already contain the header information.
 *
 * File system images without headers can be created using the makefsfile
 * tool with the -h command line option.
 */

/*
 * Notes about valid SSI tags
 * --------------------------
 *
 * The following assumptions are made about tags used in SSI markers:
 *
 * 1. No tag may contain '-' or whitespace characters within the tag name.
 * 2. Whitespace is allowed between the tag leadin "<!--#" and the start of
 *    the tag name and between the tag name and the leadout string "-->".
 * 3. The maximum tag name length is MAX_TAG_NAME_LEN, currently 8 characters.
 *
 * Notes on CGI usage
 * ------------------
 *
 * The simple CGI support offered here works with GET method requests only
 * and can handle up to 16 parameters encoded into the URI. The handler
 * function may not write directly to the HTTP output but must return a
 * filename that the HTTP server will send to the browser as a response to
 * the incoming CGI request.
 *
 */
#include "lwip/debug.h"
#include "lwip/stats.h"
#include "httpd.h"
#include "lwip/tcp.h"
#include "fs.h"

#include <string.h>

#ifndef HTTPD_DEBUG
#define HTTPD_DEBUG         LWIP_DBG_OFF
#endif

#ifndef true
#define true ((u8_t)1)
#endif

#ifndef false
#define false ((u8_t)0)
#endif

typedef struct
{
    const char *name;
    u8_t shtml;
} default_filename;

const default_filename g_psDefaultFilenames[] = {
  {"/index.shtml", true },
  {"/index.ssi", true },
  {"/index.shtm", true },
  {"/index.html", false },
  {"/index.htm", false }
};

#define NUM_DEFAULT_FILENAMES (sizeof(g_psDefaultFilenames) /                 \
                               sizeof(default_filename))

#ifdef DYNAMIC_HTTP_HEADERS
/* The number of individual strings that comprise the headers sent before each
 * requested file.
 */
#define NUM_FILE_HDR_STRINGS 3
#endif

#ifdef INCLUDE_HTTPD_SSI

/* Include the (TI-specific) micro-standard-library.  This is needed for the
 * function usnprintf which is a cut down version of the C standard snprintf.
 * Some of the toolchains we support don't support snprintf without pulling in
 * a large amount of extra (and usually extraneous) code.  If your C runtime
 * does support snprintf, this header can be removed and the call to usnprintf
 * replaced.
 */
#include "utils/ustdlib.h"

const char *g_pcSSIExtensions[] = {
  ".shtml", ".shtm", ".ssi", ".xml"
};

#define NUM_SHTML_EXTENSIONS (sizeof(g_pcSSIExtensions) / sizeof(const char *))

enum tag_check_state {
    TAG_NONE,       /* Not processing an SSI tag */
    TAG_LEADIN,     /* Tag lead in "<!--#" being processed */
    TAG_FOUND,      /* Tag name being read, looking for lead-out start */
    TAG_LEADOUT,    /* Tag lead out "-->" being processed */
    TAG_SENDING     /* Sending tag replacement string */
};
#endif /* INCLUDE_HTTPD_SSI */

struct http_state {
  struct fs_file *handle;
  char *file;       /* Pointer to first unsent byte in buf. */
  char *buf;        /* File read buffer. */
#ifdef INCLUDE_HTTPD_SSI
  char *parsed;     /* Pointer to the first unparsed byte in buf. */
  char *tag_end;    /* Pointer to char after the closing '>' of the tag. */
  u32_t parse_left; /* Number of unparsed bytes in buf. */
#endif
  u32_t left;       /* Number of unsent bytes in buf. */
  int buf_len;      /* Size of file read buffer, buf. */
  u8_t retries;
#ifdef INCLUDE_HTTPD_SSI
  u8_t tag_check;   /* true if we are processing a .shtml file else false */
  u8_t tag_index;   /* Counter used by tag parsing state machine */
  u8_t tag_insert_len; /* Length of insert in string tag_insert */
  u8_t tag_name_len; /* Length of the tag name in string tag_name */
  char tag_name[MAX_TAG_NAME_LEN + 1]; /* Last tag name extracted */
  char tag_insert[MAX_TAG_INSERT_LEN + 1]; /* Insert string for tag_name */
  enum tag_check_state tag_state; /* State of the tag processor */
#endif
#ifdef INCLUDE_HTTPD_CGI
  char *params[MAX_CGI_PARAMETERS]; /* Params extracted from the request URI */
  char *param_vals[MAX_CGI_PARAMETERS]; /* Values for each extracted param */
#endif
#ifdef DYNAMIC_HTTP_HEADERS
  const char *hdrs[NUM_FILE_HDR_STRINGS]; /* HTTP headers to be sent. */
  u16_t hdr_pos;     /* The position of the first unsent header byte in the
                        current string */
  u16_t hdr_index;   /* The index of the hdr string currently being sent. */
#endif
};

#ifdef INCLUDE_HTTPD_SSI
/* SSI insert handler function pointer. */
tSSIHandler g_pfnSSIHandler = NULL;
int g_iNumTags = 0;
const char **g_ppcTags = NULL;

#define LEN_TAG_LEAD_IN 5
const char * const g_pcTagLeadIn = "<!--#";

#define LEN_TAG_LEAD_OUT 3
const char * const g_pcTagLeadOut = "-->";
#endif /* INCLUDE_HTTPD_SSI */

#ifdef INCLUDE_HTTPD_CGI
/* CGI handler information */
const tCGI *g_pCGIs = NULL;
int g_iNumCGIs = 0;
#endif /* INCLUDE_HTTPD_CGI */

#ifdef DYNAMIC_HTTP_HEADERS
//*****************************************************************************
//
// HTTP header strings for various filename extensions.
//
//*****************************************************************************
typedef struct
{
    const char *pszExtension;
    unsigned long ulHeaderIndex;
} tHTTPHeader;

const char *g_psHTTPHeaderStrings[] =
{
 "Content-type: text/html\r\n\r\n",
 "Content-type: text/html\r\nExpires: Fri, 10 Apr 2008 14:00:00 GMT\r\n"    \
   "Pragma: no-cache\r\n\r\n",
 "Content-type: image/gif\r\n\r\n",
 "Content-type: image/png\r\n\r\n",
 "Content-type: image/jpeg\r\n\r\n",
 "Content-type: image/bmp\r\n\r\n",
 "Content-type: image/x-icon\r\n\r\n",
 "Content-type: application/octet-stream\r\n\r\n",
 "Content-type: application/x-javascript\r\n\r\n",
 "Content-type: audio/x-pn-realaudio\r\n\r\n",
 "Content-type: text/css\r\n\r\n",
 "Content-type: application/x-shockwave-flash\r\n\r\n",
 "Content-type: text/xml\r\n\r\n",
 "Content-type: text/plain\r\n\r\n",
 "HTTP/1.0 200 OK\r\n",
 "HTTP/1.0 404 File not found\r\n",
 "Server: lwIP/1.3.2 (http://www.sics.se/~adam/lwip/)\r\n",
 "\r\n<html><body><h2>404: The requested file cannot be found."             \
   "</h2></body></html>\r\n"
};

#define HTTP_HDR_HTML           0
#define HTTP_HDR_SSI            1
#define HTTP_HDR_GIF            2
#define HTTP_HDR_PNG            3
#define HTTP_HDR_JPG            4
#define HTTP_HDR_BMP            5
#define HTTP_HDR_ICO            6
#define HTTP_HDR_APP            7
#define HTTP_HDR_JS             8
#define HTTP_HDR_RA             9
#define HTTP_HDR_CSS            10
#define HTTP_HDR_SWF            11
#define HTTP_HDR_XML            12
#define HTTP_HDR_DEFAULT_TYPE   13
#define HTTP_HDR_OK             14
#define HTTP_HDR_NOT_FOUND      15
#define HTTP_HDR_SERVER         16
#define DEFAULT_404_HTML        17

tHTTPHeader g_psHTTPHeaders[] =
{
 { "html", HTTP_HDR_HTML},
 { "htm",  HTTP_HDR_HTML},
 { "shtml",HTTP_HDR_SSI},
 { "shtm", HTTP_HDR_SSI},
 { "ssi",  HTTP_HDR_SSI},
 { "gif",  HTTP_HDR_GIF},
 { "png",  HTTP_HDR_PNG},
 { "jpg",  HTTP_HDR_JPG},
 { "bmp",  HTTP_HDR_BMP},
 { "ico",  HTTP_HDR_ICO},
 { "class",HTTP_HDR_APP},
 { "cls",  HTTP_HDR_APP},
 { "js",   HTTP_HDR_JS},
 { "ram",  HTTP_HDR_RA},
 { "css",  HTTP_HDR_CSS},
 { "swf",  HTTP_HDR_SWF},
 { "xml",  HTTP_HDR_XML}
};

#define NUM_HTTP_HEADERS (sizeof(g_psHTTPHeaders) / sizeof(tHTTPHeader))

#endif

/*-----------------------------------------------------------------------------------*/
static void
conn_err(void *arg, err_t err)
{
  struct http_state *hs;

  LWIP_UNUSED_ARG(err);

  if(arg)
  {
      hs = arg;
      if(hs->handle) {
        fs_close(hs->handle);
        hs->handle = NULL;
      }
      if(hs->buf)
      {
          mem_free(hs->buf);
      }
      mem_free(hs);
  }
}
/*-----------------------------------------------------------------------------------*/
static void
close_conn(struct tcp_pcb *pcb, struct http_state *hs)
{
  err_t err;
  LWIP_DEBUGF(HTTPD_DEBUG, ("Closing connection 0x%08x\n", pcb));

  tcp_arg(pcb, NULL);
  tcp_sent(pcb, NULL);
  tcp_recv(pcb, NULL);
  if(hs) {
    if(hs->handle) {
      fs_close(hs->handle);
      hs->handle = NULL;
    }
    if(hs->buf)
    {
      mem_free(hs->buf);
    }
    mem_free(hs);
  }
  err = tcp_close(pcb);
  if(err != ERR_OK)
  {
      LWIP_DEBUGF(HTTPD_DEBUG, ("Error %d closing 0x%08x\n", err, pcb));
  }
}
/*-----------------------------------------------------------------------------------*/
#ifdef INCLUDE_HTTPD_CGI
static int
extract_uri_parameters(struct http_state *hs, char *params)
{
  char *pair;
  char *equals;
  int loop;

  /* If we have no parameters at all, return immediately. */
  if(!params || (params[0] == '\0')) {
      return(0);
  }

  /* Get a pointer to our first parameter */
  pair = params;

  /*
   * Parse up to MAX_CGI_PARAMETERS from the passed string and ignore the
   * remainder (if any)
   */
  for(loop = 0; (loop < MAX_CGI_PARAMETERS) && pair; loop++) {

    /* Save the name of the parameter */
    hs->params[loop] = pair;

    /* Remember the start of this name=value pair */
    equals = pair;

    /* Find the start of the next name=value pair and replace the delimiter
     * with a 0 to terminate the previous pair string.
     */
    pair = strchr(pair, '&');
    if(pair) {
      *pair = '\0';
      pair++;
    } else {
       /* We didn't find a new parameter so find the end of the URI and
        * replace the space with a '\0'
        */
        pair = strchr(equals, ' ');
        if(pair) {
            *pair = '\0';
        }

        /* Revert to NULL so that we exit the loop as expected. */
        pair = NULL;
    }

    /* Now find the '=' in the previous pair, replace it with '\0' and save
     * the parameter value string.
     */
    equals = strchr(equals, '=');
    if(equals) {
      *equals = '\0';
      hs->param_vals[loop] = equals + 1;
    } else {
      hs->param_vals[loop] = NULL;
    }
  }

  return(loop);
}
#endif /* INCLUDE_HTTPD_CGI */

/*-----------------------------------------------------------------------------------*/
#ifdef INCLUDE_HTTPD_SSI
static void
get_tag_insert(struct http_state *hs)
{
  int loop;

  if(g_pfnSSIHandler && g_ppcTags && g_iNumTags) {

    /* Find this tag in the list we have been provided. */
    for(loop = 0; loop < g_iNumTags; loop++)
    {
      if(strcmp(hs->tag_name, g_ppcTags[loop]) == 0) {
        hs->tag_insert_len = g_pfnSSIHandler(loop, hs->tag_insert,
                                             MAX_TAG_INSERT_LEN);
        return;
      }
    }
  }

  /* If we drop out, we were asked to serve a page which contains tags that
   * we don't have a handler for. Merely echo back the tags with an error
   * marker.
   */
  usnprintf(hs->tag_insert, (MAX_TAG_INSERT_LEN + 1),
           "<b>***UNKNOWN TAG %s***</b>", hs->tag_name);
  hs->tag_insert_len = strlen(hs->tag_insert);
}
#endif /* INCLUDE_HTTPD_SSI */

#ifdef DYNAMIC_HTTP_HEADERS
//*****************************************************************************
//
// Generate the relevant HTTP headers for the given filename and write
// them into the supplied buffer.  Returns true on success or false on failure.
//
//*****************************************************************************
static void
get_http_headers(struct http_state *pState, char *pszURI)
{
    int iLoop;
    char *pszWork;
    char *pszExt;
    char *pszVars;

    //
    // Ensure that we initialize the loop counter.
    //
    iLoop = 0;

    //
    //
    // In all cases, the second header we send is the server identification
    // so set it here.
    //
    pState->hdrs[1] = g_psHTTPHeaderStrings[HTTP_HDR_SERVER];

    // Is this a normal file or the special case we use to send back the
    // default "404: Page not found" response?
    //
    if(pszURI == NULL)
    {
        pState->hdrs[0] = g_psHTTPHeaderStrings[HTTP_HDR_NOT_FOUND];
        pState->hdrs[2] = g_psHTTPHeaderStrings[DEFAULT_404_HTML];

        //
        // Set up to send the first header string.
        //
        pState->hdr_index = 0;
        pState->hdr_pos = 0;
        return;
    }
    else
    {
        //
        // We are dealing with a particular filename. Look for one other
        // special case.  We assume that any filename with "404" in it must be
        // indicative of a 404 server error whereas all other files require
        // the 200 OK header.
        //
        if(strstr(pszURI, "404"))
        {
            pState->hdrs[0] = g_psHTTPHeaderStrings[HTTP_HDR_NOT_FOUND];
        }
        else
        {
            pState->hdrs[0] = g_psHTTPHeaderStrings[HTTP_HDR_OK];
        }

        //
        // Determine if the URI has any variables and, if so, temporarily remove
        // them.
        //
        pszVars = strchr(pszURI, '?');
        if(pszVars)
        {
            *pszVars = '\0';
        }

        //
        // Get a pointer to the file extension.  We find this by looking for the
        // last occurrence of "." in the filename passed.
        //
        pszExt = NULL;
        pszWork = strchr(pszURI, '.');
        while(pszWork)
        {
            pszExt = pszWork + 1;
            pszWork = strchr(pszExt, '.');
        }

        //
        // Now determine the content type and add the relevant header for that.
        //
        for(iLoop = 0; (iLoop < NUM_HTTP_HEADERS) && pszExt; iLoop++)
        {
            //
            // Have we found a matching extension?
            //
            if(!strcmp(g_psHTTPHeaders[iLoop].pszExtension, pszExt))
            {
                pState->hdrs[2] =
                  g_psHTTPHeaderStrings[g_psHTTPHeaders[iLoop].ulHeaderIndex];
                break;
            }
        }

        //
        // Reinstate the parameter marker if there was one in the original
        // URI.
        //
        if(pszVars)
        {
            *pszVars = '?';
        }
    }

    //
    // Does the URL passed have any file extension?  If not, we assume it
    // is a special-case URL used for control state notification and we do
    // not send any HTTP headers with the response.
    //
    if(!pszExt)
    {
        //
        // Force the header index to a value indicating that all headers
        // have already been sent.
        //
        pState->hdr_index = NUM_FILE_HDR_STRINGS;
    }
    else
    {
        //
        // Did we find a matching extension?
        //
        if(iLoop == NUM_HTTP_HEADERS)
        {
            //
            // No - use the default, plain text file type.
            //
            pState->hdrs[2] = g_psHTTPHeaderStrings[HTTP_HDR_DEFAULT_TYPE];
        }

        //
        // Set up to send the first header string.
        //
        pState->hdr_index = 0;
        pState->hdr_pos = 0;
    }
}
#endif

/*-----------------------------------------------------------------------------------*/
static void
send_data(struct tcp_pcb *pcb, struct http_state *hs)
{
  err_t err;
  u16_t len;
  u8_t data_to_send = false;
#ifdef DYNAMIC_HTTP_HEADERS
  u16_t hdrlen, sendlen;

  /* If we were passed a NULL state structure pointer, ignore the call. */
  if(!hs) {
      return;
  }

  /* Assume no error until we find otherwise */
  err = ERR_OK;

  /* Do we have any more header data to send for this file? */
  if(hs->hdr_index < NUM_FILE_HDR_STRINGS)
  {
      /* How much data can we send? */
      len = tcp_sndbuf(pcb);
      sendlen = len;

      while(len && (hs->hdr_index < NUM_FILE_HDR_STRINGS) && sendlen)
      {
          /* How much do we have to send from the current header? */
          hdrlen = strlen(hs->hdrs[hs->hdr_index]);

          /* How much of this can we send? */
          sendlen = (len < (hdrlen - hs->hdr_pos)) ?
                          len : (hdrlen - hs->hdr_pos);

          /* Send this amount of data or as much as we can given memory
           * constraints. */
          do {
            err = tcp_write(pcb, (const void *)(hs->hdrs[hs->hdr_index] +
                            hs->hdr_pos), sendlen, 0);
            if (err == ERR_MEM) {
              sendlen /= 2;
            }
            else if (err == ERR_OK) {
              /* Remember that we added some more data to be transmitted. */
              data_to_send = true;
            }
          } while ((err == ERR_MEM) && sendlen);

          /* Fix up the header position for the next time round. */
          hs->hdr_pos += sendlen;
          len -= sendlen;

          /* Have we finished sending this string? */
          if(hs->hdr_pos == hdrlen) {
              /* Yes - move on to the next one */
              hs->hdr_index++;
              hs->hdr_pos = 0;
          }
      }

      /* If we get here and there are still header bytes to send, we send
       * the header information we just wrote immediately.  If there are no
       * more headers to send, but we do have file data to send, drop through
       * to try to send some file data too.
       */
      if((hs->hdr_index < NUM_FILE_HDR_STRINGS) || !hs->file) {
        LWIP_DEBUGF(HTTPD_DEBUG, ("tcp_output\n"));
        tcp_output(pcb);
        return;
      }
  }
#else
  /* Assume no error until we find otherwise */
  err = ERR_OK;
#endif

  /* Have we run out of file data to send? If so, we need to read the next
   * block from the file.
   */
  if(hs->left == 0)
  {
    int count;

    /* Do we already have a send buffer allocated? */
    if(hs->buf) {
      /* Yes - get the length of the buffer */
      count = hs->buf_len;
    }
    else {
      /* We don't have a send buffer so allocate one up to 2mss bytes long. */
      count = 2 * pcb->mss;
      do {
        hs->buf = mem_malloc(count);
        if(hs->buf) {
          hs->buf_len = count;
          break;
        }
        count = count / 2;
      }while (count > 100);

      /* Did we get a send buffer? If not, return immediately. */
      if(hs->buf == NULL) {
        LWIP_DEBUGF(HTTPD_DEBUG, ("No buff\n"));
        return;
      }
    }

    /* Do we have a valid file handle? */
    if(hs->handle == NULL)
    {
        //
        // No - close the connection.
        //
        close_conn(pcb, hs);
        return;
    }

    /* Read a block of data from the file. */
    LWIP_DEBUGF(HTTPD_DEBUG, ("Trying to read %d bytes.\n", count));

    count = fs_read(hs->handle, hs->buf, count);
    if(count < 0) {
      /* We reached the end of the file so this request is done */
      LWIP_DEBUGF(HTTPD_DEBUG, ("End of file.\n"));
      fs_close(hs->handle);
      hs->handle = NULL;
      close_conn(pcb, hs);
      return;
    }

    /* Set up to send the block of data we just read */
    LWIP_DEBUGF(HTTPD_DEBUG, ("Read %d bytes.\n", count));
    hs->left = count;
    hs->file = hs->buf;
#ifdef INCLUDE_HTTPD_SSI
    hs->parse_left = count;
    hs->parsed = hs->buf;
#endif
  }

#ifdef INCLUDE_HTTPD_SSI
  if(!hs->tag_check) {
#endif
      /* We are not processing an SHTML file so no tag checking is necessary.
       * Just send the data as we received it from the file.
       */

      /* We cannot send more data than space available in the send
         buffer. */
      if (tcp_sndbuf(pcb) < hs->left) {
        len = tcp_sndbuf(pcb);
      } else {
        len = hs->left;
        LWIP_ASSERT("hs->left did not fit into u16_t!", (len == hs->left));
      }
      if(len > (2*pcb->mss)) {
        len = 2*pcb->mss;
      }

      do {
        LWIP_DEBUGF(HTTPD_DEBUG, ("Sending %d bytes\n", len));

        /* If the data is being read from a buffer in RAM, we need to copy it
         * into the PCB. If it's in flash, however, we can avoid the copy since
         * the data is obviously not going to be overwritten during the life
         * of the connection.
         */
        err = tcp_write(pcb, hs->file, len,
                        (hs->file < (char *)0x20000000) ? 0 : 1);
        if (err == ERR_MEM) {
          len /= 2;
        }
      } while (err == ERR_MEM && len > 1);

      if (err == ERR_OK) {
        data_to_send = true;
        hs->file += len;
        hs->left -= len;
      }
#ifdef INCLUDE_HTTPD_SSI
  } else {
    /* We are processing an SHTML file so need to scan for tags and replace
     * them with insert strings. We need to be careful here since a tag may
     * straddle the boundary of two blocks read from the file and we may also
     * have to split the insert string between two tcp_write operations.
     */

    /* How much data could we send? */
    len = tcp_sndbuf(pcb);

    /* Do we have remaining data to send before parsing more? */
    if(hs->parsed > hs->file) {
        /* We cannot send more data than space available in the send
           buffer. */
        if (tcp_sndbuf(pcb) < (hs->parsed - hs->file)) {
          len = tcp_sndbuf(pcb);
        } else {
          len = (hs->parsed - hs->file);
          LWIP_ASSERT("Data size did not fit into u16_t!",
                      (hs->parsed - hs->file));
        }
        if(len > (2*pcb->mss)) {
          len = 2*pcb->mss;
        }

        do {
          LWIP_DEBUGF(HTTPD_DEBUG, ("Sending %d bytes\n", len));
          err = tcp_write(pcb, hs->file, len, 0);
          if (err == ERR_MEM) {
            len /= 2;
          }
        } while (err == ERR_MEM && len > 1);

        if (err == ERR_OK) {
          data_to_send = true;
          hs->file += len;
          hs->left -= len;
        }

        //
        // If the send buffer is full, return now.
        //
        if(tcp_sndbuf(pcb) == 0) {
          if(data_to_send) {
            tcp_output(pcb);
            LWIP_DEBUGF(HTTPD_DEBUG, ("Output\n"));
          }
          return;
        }
    }

    LWIP_DEBUGF(HTTPD_DEBUG, ("State %d, %d left\n", hs->tag_state, hs->parse_left));

    /* We have sent all the data that was already parsed so continue parsing
     * the buffer contents looking for SSI tags.
     */
    while((hs->parse_left) && (err == ERR_OK)) {
      switch(hs->tag_state) {
        case TAG_NONE:
          /* We are not currently processing an SSI tag so scan for the
           * start of the lead-in marker.
           */
          if(*hs->parsed == g_pcTagLeadIn[0])
          {
              /* We found what could be the lead-in for a new tag so change
               * state appropriately.
               */
              hs->tag_state = TAG_LEADIN;
              hs->tag_index = 1;
          }

          /* Move on to the next character in the buffer */
          hs->parse_left--;
          hs->parsed++;
          break;

        case TAG_LEADIN:
          /* We are processing the lead-in marker, looking for the start of
           * the tag name.
           */

          /* Have we reached the end of the leadin? */
          if(hs->tag_index == LEN_TAG_LEAD_IN) {
              hs->tag_index = 0;
              hs->tag_state = TAG_FOUND;
          } else {
            /* Have we found the next character we expect for the tag leadin?
             */
            if(*hs->parsed == g_pcTagLeadIn[hs->tag_index]) {
              /* Yes - move to the next one unless we have found the complete
               * leadin, in which case we start looking for the tag itself
               */
              hs->tag_index++;
            } else {
              /* We found an unexpected character so this is not a tag. Move
               * back to idle state.
               */
              hs->tag_state = TAG_NONE;
            }

            /* Move on to the next character in the buffer */
            hs->parse_left--;
            hs->parsed++;
          }
          break;

        case TAG_FOUND:
          /* We are reading the tag name, looking for the start of the
           * lead-out marker and removing any whitespace found.
           */

          /* Remove leading whitespace between the tag leading and the first
           * tag name character.
           */
          if((hs->tag_index == 0) && ((*hs->parsed == ' ') ||
             (*hs->parsed == '\t') || (*hs->parsed == '\n') ||
             (*hs->parsed == '\r')))
          {
              /* Move on to the next character in the buffer */
              hs->parse_left--;
              hs->parsed++;
              break;
          }

          /* Have we found the end of the tag name? This is signalled by
           * us finding the first leadout character or whitespace */
          if((*hs->parsed == g_pcTagLeadOut[0]) ||
             (*hs->parsed == ' ') || (*hs->parsed == '\t') ||
             (*hs->parsed == '\n')  || (*hs->parsed == '\r')) {

            if(hs->tag_index == 0) {
              /* We read a zero length tag so ignore it. */
              hs->tag_state = TAG_NONE;
            } else {
              /* We read a non-empty tag so go ahead and look for the
               * leadout string.
               */
              hs->tag_state = TAG_LEADOUT;
              hs->tag_name_len = hs->tag_index;
              hs->tag_name[hs->tag_index] = '\0';
              if(*hs->parsed == g_pcTagLeadOut[0]) {
                hs->tag_index = 1;
              } else {
                hs->tag_index = 0;
              }
            }
          } else {
            /* This character is part of the tag name so save it */
            if(hs->tag_index < MAX_TAG_NAME_LEN) {
              hs->tag_name[hs->tag_index++] = *hs->parsed;
            } else {
              /* The tag was too long so ignore it. */
              hs->tag_state = TAG_NONE;
            }
          }

          /* Move on to the next character in the buffer */
          hs->parse_left--;
          hs->parsed++;

          break;

        /*
         * We are looking for the end of the lead-out marker.
         */
        case TAG_LEADOUT:
          /* Remove leading whitespace between the tag leading and the first
           * tag leadout character.
           */
          if((hs->tag_index == 0) && ((*hs->parsed == ' ') ||
             (*hs->parsed == '\t') || (*hs->parsed == '\n') ||
             (*hs->parsed == '\r')))
          {
            /* Move on to the next character in the buffer */
            hs->parse_left--;
            hs->parsed++;
            break;
          }

          /* Have we found the next character we expect for the tag leadout?
           */
          if(*hs->parsed == g_pcTagLeadOut[hs->tag_index]) {
            /* Yes - move to the next one unless we have found the complete
             * leadout, in which case we need to call the client to process
             * the tag.
             */

            /* Move on to the next character in the buffer */
            hs->parse_left--;
            hs->parsed++;

            if(hs->tag_index == (LEN_TAG_LEAD_OUT - 1)) {
              /* Call the client to ask for the insert string for the
               * tag we just found.
               */
              get_tag_insert(hs);

              /* Next time through, we are going to be sending data
               * immediately, either the end of the block we start
               * sending here or the insert string.
               */
              hs->tag_index = 0;
              hs->tag_state = TAG_SENDING;
              hs->tag_end = hs->parsed;

              /* If there is any unsent data in the buffer prior to the
               * tag, we need to send it now.
               */
              if(hs->tag_end > hs->file)
              {
                /* How much of the data can we send? */
                if(len > hs->tag_end - hs->file) {
                    len = hs->tag_end - hs->file;
                }

                do {
                  LWIP_DEBUGF(HTTPD_DEBUG, ("Sending %d bytes\n", len));
                  err = tcp_write(pcb, hs->file, len, 0);
                  if (err == ERR_MEM) {
                    len /= 2;
                  }
                } while (err == ERR_MEM && (len > 1));

                if (err == ERR_OK) {
                  data_to_send = true;
                  hs->file += len;
                  hs->left -= len;
                }
              }
            } else {
              hs->tag_index++;
            }
          } else {
              /* We found an unexpected character so this is not a tag. Move
               * back to idle state.
               */
              hs->parse_left--;
              hs->parsed++;
              hs->tag_state = TAG_NONE;
          }
          break;

        /*
         * We have found a valid tag and are in the process of sending
         * data as a result of that discovery. We send either remaining data
         * from the file prior to the insert point or the insert string itself.
         */
        case TAG_SENDING:
          /* Do we have any remaining file data to send from the buffer prior
           * to the tag?
           */
          if(hs->tag_end > hs->file)
          {
            /* How much of the data can we send? */
            if(len > hs->tag_end - hs->file) {
              len = hs->tag_end - hs->file;
            }

            do {
              LWIP_DEBUGF(HTTPD_DEBUG, ("Sending %d bytes\n", len));
              err = tcp_write(pcb, hs->file, len, 0);
              if (err == ERR_MEM) {
                len /= 2;
              }
            } while (err == ERR_MEM && (len > 1));

            if (err == ERR_OK) {
              data_to_send = true;
              hs->file += len;
              hs->left -= len;
            }
          } else {
            /* Do we still have insert data left to send? */
            if(hs->tag_index < hs->tag_insert_len) {
              /* We are sending the insert string itself. How much of the
               * insert can we send? */
              if(len > (hs->tag_insert_len - hs->tag_index)) {
                len = (hs->tag_insert_len - hs->tag_index);
              }

              do {
                LWIP_DEBUGF(HTTPD_DEBUG, ("Sending %d bytes\n", len));
                /*
                 * Note that we set the copy flag here since we only have a
                 * single tag insert buffer per connection. If we don't do
                 * this, insert corruption can occur if more than one insert
                 * is processed before we call tcp_output.
                 */
                err = tcp_write(pcb, &(hs->tag_insert[hs->tag_index]), len, 1);
                if (err == ERR_MEM) {
                  len /= 2;
                }
              } while (err == ERR_MEM && (len > 1));

              if (err == ERR_OK) {
                data_to_send = true;
                hs->tag_index += len;
              }
            } else {
              /* We have sent all the insert data so go back to looking for
               * a new tag.
               */
              LWIP_DEBUGF(HTTPD_DEBUG, ("Everything sent.\n"));
              hs->tag_index = 0;
              hs->tag_state = TAG_NONE;
          }
        }
      }
    }

    /*
     * If we drop out of the end of the for loop, this implies we must have
     * file data to send so send it now. In TAG_SENDING state, we've already
     * handled this so skip the send if that's the case.
     */
    if((hs->tag_state != TAG_SENDING) && (hs->parsed > hs->file)) {
      /* We cannot send more data than space available in the send
         buffer. */
      if (tcp_sndbuf(pcb) < (hs->parsed - hs->file)) {
        len = tcp_sndbuf(pcb);
      } else {
        len = (hs->parsed - hs->file);
        LWIP_ASSERT("Data size did not fit into u16_t!",
                    (hs->parsed - hs->file));
      }
      if(len > (2*pcb->mss)) {
        len = 2*pcb->mss;
      }

      do {
        LWIP_DEBUGF(HTTPD_DEBUG, ("Sending %d bytes\n", len));
        err = tcp_write(pcb, hs->file, len, 0);
        if (err == ERR_MEM) {
          len /= 2;
        }
      } while (err == ERR_MEM && len > 1);

      if (err == ERR_OK) {
        data_to_send = true;
        hs->file += len;
        hs->left -= len;
      }
    }
  }
#endif /* INCLUDE_HTTPD_SSI */

  /* If we wrote anything to be sent, go ahead and send it now. */
  if(data_to_send) {
    LWIP_DEBUGF(HTTPD_DEBUG, ("tcp_output\n"));
    tcp_output(pcb);
  }

  LWIP_DEBUGF(HTTPD_DEBUG, ("send_data end.\n"));
}

/*-----------------------------------------------------------------------------------*/
static err_t
http_poll(void *arg, struct tcp_pcb *pcb)
{
  struct http_state *hs;

  hs = arg;

  LWIP_DEBUGF(HTTPD_DEBUG, ("http_poll 0x%08x\n", pcb));

  /*  printf("Polll\n");*/
  if ((hs == NULL) && (pcb->state == ESTABLISHED)) {
    /*    printf("Null, close\n");*/
    tcp_abort(pcb);
    return ERR_ABRT;
  } else {
    ++hs->retries;
    if (hs->retries == 4) {
      tcp_abort(pcb);
      return ERR_ABRT;
    }

    /* If this connection has a file open, try to send some more data. If
     * it has not yet received a GET request, don't do this since it will
     * cause the connection to close immediately. */
    if(hs && (hs->handle)) {
      send_data(pcb, hs);
    }
  }

  return ERR_OK;
}
/*-----------------------------------------------------------------------------------*/
static err_t
http_sent(void *arg, struct tcp_pcb *pcb, u16_t len)
{
  struct http_state *hs;

  LWIP_DEBUGF(HTTPD_DEBUG, ("http_sent 0x%08x\n", pcb));

  LWIP_UNUSED_ARG(len);

  if(!arg) {
    return ERR_OK;
  }

  hs = arg;

  hs->retries = 0;

  /* Temporarily disable send notifications */
  tcp_sent(pcb, NULL);

  send_data(pcb, hs);

  /* Reenable notifications. */
  tcp_sent(pcb, http_sent);

  return ERR_OK;
}

/*-----------------------------------------------------------------------------------*/
static struct fs_file *
get_404_file(char **ppURI)
{
  struct fs_file *file;

  *ppURI = "/404.html";
  file = fs_open(*ppURI);
  if(file == NULL) {
    /* 404.html doesn't exist. Try 404.htm instead. */
    *ppURI = "/404.htm";
    file = fs_open(*ppURI);
    if(file == NULL) {
      /* 404.htm doesn't exist either. Indicate to the caller that it should
       * send back a default 404 page.
       */
      *ppURI = NULL;
    }
  }

  return(file);
}

/*-----------------------------------------------------------------------------------*/
static err_t
http_recv(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err)
{
  int i;
  int loop;
  char *data;
  char *uri;
  struct fs_file *file;
  struct http_state *hs;
#ifdef INCLUDE_HTTPD_CGI
  int count;
  char *params;
#endif

  LWIP_DEBUGF(HTTPD_DEBUG, ("http_recv 0x%08x\n", pcb));

  hs = arg;

  if ((err == ERR_OK) && (p != NULL) && hs) {

    /* Inform TCP that we have taken the data. */
    tcp_recved(pcb, p->tot_len);

    if (hs->handle == NULL) {
      data = p->payload;
      uri = &data[4];
      LWIP_DEBUGF(HTTPD_DEBUG, ("Request:\n%s\n", data));
      if (strncmp(data, "GET ", 4) == 0) {
        /*
         * We have a GET request. Find the end of the URI by looking for the
         * HTTP marker. We can't just use strstr to find this since the request
         * came from an outside source and we can't be sure that it is
         * correctly formed. We need to make sure that our search is bounded
         * by the packet length so we do it manually. If we don't find " HTTP",
         * assume the request is invalid and close the connection.
         */
        for(i = 4; i < (p->len - 5); i++) {
          if ((data[i] == ' ') && (data[i + 1] == 'H') &&
              (data[i + 2] == 'T') && (data[i + 3] == 'T') &&
              (data[i + 4] == 'P')) {
            data[i] = 0;
            break;
          }
        }
        if(i == (p->len - 5)) {
          /* We failed to find " HTTP" in the request so assume it is invalid */
          LWIP_DEBUGF(HTTPD_DEBUG, ("Invalid GET request. Closing.\n"));
          pbuf_free(p);
          close_conn(pcb, hs);
          return(ERR_OK);
        }

#ifdef INCLUDE_HTTPD_SSI
        /*
         * By default, assume we will not be processing server-side-includes
         * tags
         */
        hs->tag_check = false;
#endif

        /*
         * Have we been asked for the default root file?
         */
        if((uri[0] == '/') &&  (uri[1] == 0)) {
          /*
           * Try each of the configured default filenames until we find one
           * that exists.
           */
          for(loop = 0; loop < NUM_DEFAULT_FILENAMES; loop++) {
            LWIP_DEBUGF(HTTPD_DEBUG, ("Looking for %s...\n", g_psDefaultFilenames[loop].name));
            file = fs_open((char *)g_psDefaultFilenames[loop].name);
            uri = (char *)g_psDefaultFilenames[loop].name;
            if(file != NULL) {
              LWIP_DEBUGF(HTTPD_DEBUG, ("Opened.\n"));
#ifdef INCLUDE_HTTPD_SSI
              hs->tag_check = g_psDefaultFilenames[loop].shtml;
#endif
              break;
            }
          }
          if(file == NULL) {
            /* None of the default filenames exist so send back a 404 page */
            file = get_404_file(&uri);
#ifdef INCLUDE_HTTPD_SSI
            hs->tag_check = false;
#endif
          }
        } else {
          /* No - we've been asked for a specific file. */
#ifdef INCLUDE_HTTPD_CGI
          /* First, isolate the base URI (without any parameters) */
          params = strchr(uri, '?');
          if(params) {
            *params = '\0';
            params++;
          }

          /* Does the base URI we have isolated correspond to a CGI handler? */
          if(g_iNumCGIs && g_pCGIs) {
            for(i = 0; i < g_iNumCGIs; i++) {
              if(strcmp(uri, g_pCGIs[i].pcCGIName) == 0) {
                /*
                 * We found a CGI that handles this URI so extract the
                 * parameters and call the handler.
                 */
                 count = extract_uri_parameters(hs, params);
                 uri = g_pCGIs[i].pfnCGIHandler(i, count, hs->params,
                                                hs->param_vals);
                 break;
              }
            }

            /* Did we handle this URL as a CGI? If not, reinstate the
             * original URL and pass it to the file system directly. */
            if(i == g_iNumCGIs)
            {
              /* Replace the ? marker at the beginning of the parameters */
              if(params) {
                 params--;
                *params = '?';
              }
            }
          }
#endif

          LWIP_DEBUGF(HTTPD_DEBUG, ("Opening %s\n", uri));

          file = fs_open(uri);
          if(file == NULL) {
            file = get_404_file(&uri);
          }
#ifdef INCLUDE_HTTPD_SSI
          else {
            /*
             * See if we have been asked for an shtml file and, if so,
             * enable tag checking.
             */
            hs->tag_check = false;
            for(loop = 0; loop < NUM_SHTML_EXTENSIONS; loop++) {
              if(strstr(uri, g_pcSSIExtensions[loop])) {
                hs->tag_check = true;
                break;
              }
            }
          }
#endif /* INCLUDE_HTTP_SSI */
        }

        if(file) {
#ifdef INCLUDE_HTTPD_SSI
          hs->tag_index = 0;
          hs->tag_state = TAG_NONE;
          hs->parsed = file->data;
          hs->parse_left = file->len;
          hs->tag_end = file->data;
#endif
          hs->handle = file;
          hs->file = file->data;
          LWIP_ASSERT("File length must be positive!", (file->len >= 0));
          hs->left = file->len;
          hs->retries = 0;
          pbuf_free(p);
        } else {
          hs->handle = NULL;
          hs->file = NULL;
          hs->left = 0;
          hs->retries = 0;
        }

#ifdef DYNAMIC_HTTP_HEADERS
        /* Determine the HTTP headers to send based on the file extension of
         * the requested URI. */
        get_http_headers(hs, uri);
#endif

        /* Tell TCP that we wish be to informed of data that has been
           successfully sent by a call to the http_sent() function. */
        tcp_sent(pcb, http_sent);

        /* Start sending the headers and file data. */
        send_data(pcb, hs);
      } else {
        pbuf_free(p);
        close_conn(pcb, hs);
      }
    } else {
      pbuf_free(p);
    }
  }

  if ((err == ERR_OK) && (p == NULL)) {
    close_conn(pcb, hs);
  }
  return ERR_OK;
}
/*-----------------------------------------------------------------------------------*/
static err_t
http_accept(void *arg, struct tcp_pcb *pcb, err_t err)
{
  struct http_state *hs;

  LWIP_UNUSED_ARG(arg);
  LWIP_UNUSED_ARG(err);

  LWIP_DEBUGF(HTTPD_DEBUG, ("http_accept 0x%08x\n", pcb));

  /* Allocate memory for the structure that holds the state of the
     connection. */
  hs = (struct http_state *)mem_malloc(sizeof(struct http_state));

  if (hs == NULL) {
    LWIP_DEBUGF(HTTPD_DEBUG, ("http_accept: Out of memory\n"));
    return ERR_MEM;
  }

  /* Initialize the structure. */
  hs->handle = NULL;
  hs->file = NULL;
  hs->buf = NULL;
  hs->buf_len = 0;
  hs->left = 0;
  hs->retries = 0;
#ifdef DYNAMIC_HTTP_HEADERS
  /* Indicate that the headers are not yet valid */
  hs->hdr_index = NUM_FILE_HDR_STRINGS;
#endif

  /* Tell TCP that this is the structure we wish to be passed for our
     callbacks. */
  tcp_arg(pcb, hs);

  /* Tell TCP that we wish to be informed of incoming data by a call
     to the http_recv() function. */
  tcp_recv(pcb, http_recv);

  tcp_err(pcb, conn_err);

  tcp_poll(pcb, http_poll, 4);
  return ERR_OK;
}
/*-----------------------------------------------------------------------------------*/
void
httpd_init(void)
{
  struct tcp_pcb *pcb;

  LWIP_DEBUGF(HTTPD_DEBUG, ("httpd_init\n"));

  pcb = tcp_new();
  tcp_bind(pcb, IP_ADDR_ANY, 80);
  pcb = tcp_listen(pcb);
  tcp_accept(pcb, http_accept);
}

#ifdef INCLUDE_HTTPD_SSI
/*-----------------------------------------------------------------------------------*/
void
http_set_ssi_handler(tSSIHandler pfnSSIHandler, const char **ppcTags,
                     int iNumTags)
{
    LWIP_DEBUGF(HTTPD_DEBUG, ("http_set_ssi_handler\n"));

    g_pfnSSIHandler = pfnSSIHandler;
    g_ppcTags = ppcTags;
    g_iNumTags = iNumTags;
}
#endif

#ifdef INCLUDE_HTTPD_CGI
/*-----------------------------------------------------------------------------------*/
void
http_set_cgi_handlers(const tCGI *pCGIs, int iNumHandlers)
{
    g_pCGIs = pCGIs;
    g_iNumCGIs = iNumHandlers;
}
#endif

/*-----------------------------------------------------------------------------------*/
