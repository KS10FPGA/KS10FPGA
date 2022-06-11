# KS10 FPGA Microcode

The DEC KS10 CPU was implemented using 2048 words of 108-bit wide
<a href="https://en.wikipedia.org/wiki/Microcode#Horizontal_microcode">horizontal microcode</a>.

Note: In actual practice, the KS10 microcode RAM (CRAM) was only 96 bits wide. A
post-processing tool removed some microcode fields, rearranged most fields, and
added parity to the microcode.

The DEC KS10 microsequencer had a 12-bit address which could have supported
4096 words of microcode; however, only half of the microcode memory was actually
implemented in the production hardware. Unfortunately, over time, the microcode
grew to be larger 2048 words. When that occured, DEC split the microcode and
shipped three version of the microcode – each matching a specific application:
TOPS10 Paging (T10KI), TOPS20 Paging (T10KL), or Diagnostics (KS10). When the
machine was booted, the boot disk (or tape) had the correct version of the
microcode installed so Console boot software could load the correct microcode
into Control RAM.

## KS10 Microcode Variations

The following microcode variants for the KS10 are avalable:

<div>
  <div align="center">
    <table border="1">
      <thead>
        <col width="150">
        <col width="150">
        <col width="450">
        <tr>
          <td colspan="3"><p align="center"><b>Microcode Files</b></p></td>
        </tr>
        <tr>
          <td><p align="center"><b>Filename(s)</b></p></td>
          <td colspan="2"><p align="center"><b>Description</b></p></td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><p align="center">KS10.MCR</p></td>
          <td colspan="2">
            <p>Diagnostic microcode.<p>
            <p>Includes TOPS10 paging and TOPS20 paging but does not include
               the UBABLT instructions.
            </p>
          </td>
        </tr>
        <tr>
          <td>
            <p align="center">T10KI.MCR</p>
          </td>
          <td colspan="2">
            <p>TOPS10 microcode.</p>
            <p>Includes TOPS10 paging and UBABLT instructions but does not
               include TOPS20 paging.
            </p>
          </td>
        </tr>
        <tr>
          <td><p align="center">T10KL.MCR</p></td>
          <td colspan="2">
            <p>TOPS20 microcode.</p>
            <p>
              Includes TOPS20 paging and UBABLT instructions but does not
              include TOPS10 paging.
            </p>
          </td>
        </tr>
        <tr>
          <td rowspan="11"><p align="center">CRAM4K.MCR</p></td>
          <td colspan="2">
            <p>KS10 FPGA microcode.</p>
            <p>
              Includes TOPS10 paging, TOPS20 paging, and UBABLT instructions.
              This requires 4K of microcode storage and therefore only works
              with the KS10 FPGA.
            </p>
            <p>
              The APRID instruction reports 470130_010001 which is decoded
              below:
            </p>
          </td>
        </tr>
        <tr>
          <td><p align="center"><b>Option</b></p></td>
          <td><p align="center"><b>Description</b></p></td>
        </tr>
        <tr>
          <td><p align="center">INHCST=1</p></td>
          <td><p>Allow inhibit of CST update if CSB = 0</p></td>
        </tr>
        <tr>
          <td><p align="center">NOCST=0</p></td>
          <td><p>Include support for writing the CST</p></td>
        </tr>
        <tr>
          <td><p align="center">NONSTD=0</p></td>
          <td><p>Standard microcode</p></td>
        </tr>
        <tr>
          <td><p align="center">UBABLT=1</p></td>
          <td><p>Support UBABLT instructions</p></td>
        </tr>
        <tr>
          <td><p align="center">KIPAG=1</p></td>
          <td><p>Support KI paging</p></td>
        </tr>
        <tr>
          <td><p align="center">KLPAG=1</p></td>
          <td><p>Support KL paging</p></td>
        </tr>
        <tr>
          <td><p align="center">MCV=130</p></td>
          <td><p>Microcode version</p></td>
        </tr>
        <tr>
          <td><p align="center">HO=0</p></td>
          <td><p>Hardware options</p></td>
        </tr>
        <tr>
          <td><p align="center">HSN=4097</p></td>
          <td><p>Hardware Serial Number</p></td>
        </tr>
       </tbody>
    </table>
  </div>
</div>

## KS10 FPGA Microcode Modifications

It was desirable for the KS10 FPGA to have all of the microcode features in ROM.
Therefore, unlike the DEC KS10, the KS10 FPGA implements all 4096 words of
microcode.  The additional microcode memory allowed the KS10 FPGA to support a
functional superset of all of the DEC microcode.

Fortunately all three versions of KS10 microcode were derived from a single
codebase using conditional compiles to remove microcode as required.
Implementing the new version of unified microcode only required some minor
modifications to the conditional compiles and build command files as follows:

<ul>
  <li>Conditional compiles were modified to include KI10 Paging, KL10 Paging,
    and UBABLT on machines with 4K of microcode memory.</li>
  <li>The PAGE-FAIL address moved from 3777 to 7777 on machines with 4K of
    microcode memory.  The PAGE-FAIL must be the address with all bits set.</li>
  <li>The minor microcode version (UCR) was changed from 0 to 1.</ul>
</ul>

Other than these minor changes, there were no changes to the microcode
functionality.

## Building the Microcode

The microcode build procedure is described on the
<a href="https://github.com/KS10FPGA/KS10FPGA/wiki/Building-the-Microcode">Building the Microcode</a>
wiki page and is not repeated here.

## Microcode Files

### Microcode Source Files

These source files are shared between all microcode variants.

<div>
  <div align="center">
    <table border="1">
      <thead>
        <col width="150">
        <col width="600">
        <tr>
          <td colspan="2"><p align="center"><b>KS10 Microcode Source Files</b></p></td>
        </tr>
        <tr>
          <td><p align="center"><b>Filename</b></p></td>
          <td><p align="center"><b>Description</b></p></td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><p align="center"><a href="KS10.MIC">KS10.MIC</a></p></td>
          <td><p>Microcode definitions.</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="EXTEND.MIC">EXTEND.MIC</a></p></td>
          <td><p>Microcode for extended instructions.</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="FLT.MIC">FLT.MIC</a></p></td>
          <td><p>Microcode for floating-point instructions.</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="INOUT.MIC">INOUT.MIC</a></p></td>
          <td><p>Microcode for IO instructions.</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="PAGEF.MIC">PAGEF.MIC</a></p></td>
          <td><p>Microcode for Page Fail handler.</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="SIMPLE.MIC">SIMPLE.MIC</a></p></td>
          <td><p>Microcode for simple instructions.</p></td>
        </tr>
       </tbody>
    </table>
  </div>
</div>

### KS10 (Diagnostic) Microcode Files

These files are associated with the KS10 (Diagnostic) microcode.

<div>
  <div align="center">
    <table border="1">
      <thead>
        <col width="150">
        <col width="600">
        <tr>
          <td colspan="2"><p align="center"><b>KS10 (Diagnostic) Microcode Files</b></p></td>
        </tr>
        <tr>
          <td><p align="center"><b>Filename</b></p></td>
          <td><p align="center"><b>Description</b></p></td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><p align="center"><a href="ks10.cmd">KS10.CMD</a></p></td>
          <td><p>Microcode build command file (script)</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="KS10.MCR">KS10.MCR</a></p></td>
          <td><p>Microcode listing file <b>(Not currently on the tape)</b></p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="KS10.RAM">KS10.RAM</a></p></td>
          <td><p>Machine readable microcode output file <b>(Not currently on the tape)</b></p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="KS10.ULD">KS10.ULD</a></p></td>
          <td><p>Human readable Microcode output file <b>(Not currently on the tape)</b></td>
        </tr>
       </tbody>
    </table>
  </div>
</div>

### TOPS10 (T10KI) Microcode Files

These files are associated with the TOPS10 (T10KI) microcode.

<div>
  <div align="center">
    <table border="1">
      <thead>
        <col width="150">
        <col width="600">
        <tr>
          <td colspan="2"><p align="center"><b>TOPS10 (T10KI) Microcode Files</b></p></td>
        </tr>
        <tr>
          <td><p align="center"><b>Filename</b></p></td>
          <td><p align="center"><b>Description</b></p></td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><p align="center"><a href="t10ki.mic">T10KI.MIC</a></p></td>
          <td><p>Conditional compile definitions for TOPS10 (T10KI) microcode</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="t10ki.cmd">T10KI.CMD</a></p></td>
          <td><p>Microcode build command file (script)</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="t10ki.mcr">T10KI.MCR</a></p></td>
          <td><p>Microcode listing file</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="t10ki.ram">T10KI.RAM</a></p></td>
          <td><p>Machine readable microcode output file</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="t10ki.uld">T10KI.ULD</a></p></td>
          <td><p>Human readable microcode output file</td>
        </tr>
       </tbody>
    </table>
  </div>
</div>

### TPOS20 (T10KL) Microcode Files

These files are associated with the TOPS20 (T10KL) microcode.

<div>
  <div align="center">
    <table border="1">
      <thead>
        <col width="150">
        <col width="600">
        <tr>
          <td colspan="2"><p align="center"><b>TOPS20 (T10KL) Microcode Files</b></p></td>
        </tr>
        <tr>
          <td><p align="center"><b>Filename</b></p></td>
          <td><p align="center"><b>Description</b></p></td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><p align="center"><a href="t10kl.mic">T10KL.MIC</a></p></td>
          <td><p>Conditional compile definitions for TOPS20 (T10KL) microcode</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="t10kl.cmd">T10KL.CMD</a></p></td>
          <td><p>Microcode build command file (script)</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="t10kl.mcr">T10KL.MCR</a></p></td>
          <td><p>Microcode listing file</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="t10kl.ram">T10KL.RAM</a></p></td>
          <td><p>Machine readable microcode output file</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="t10kl.uld">T10KL.ULD</a></p></td>
          <td><p>Human readable microcode output file</td>
        </tr>
       </tbody>
    </table>
  </div>
</div>

### KS10 FPGA (CRAM4K) Microcode Files

These files are associated with the KS10 FPGA (CRAM4K) microcode.

<div>
  <div align="center">
    <table border="1">
      <thead>
        <col width="150">
        <col width="600">
        <tr>
          <td colspan="2"><p align="center"><b>KS10 FPGA (CRAM4K) Microcode Files</b></p></td>
        </tr>
        <tr>
          <td><p align="center"><b>Filename</b></p></td>
          <td><p align="center"><b>Description</b></p></td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><p align="center"><a href="cram4k.mic">CRAM4K.MIC</a></p></td>
          <td><p>Conditional compile definitions for KS10 FPGA (CRAM4K) microcode</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="cram4k.cmd">CRAM4K.CMD</a></p></td>
          <td>
            <p>Microcode build command file (script)</p>
            <p>My virus scanner hates this file.</p>
          </td>
        </tr>
        <tr>
          <td><p align="center"><a href="cram4k.mcr">CRAM4K.MCR</a></p></td>
          <td><p>Microcode listing file</p></td>
        </tr>
        <tr>
          <td><p align="center"><a href="CRAM4K.RAMr">CRAM4K.RAM</a></p></td>
          <td><p>Machine readable microcode output file <b>(Not currently on the tape)</b></td>
        </tr>
        <tr>
          <td><p align="center"><a href="cram4k.uld">CRAM4K.ULD</a></p></td>
          <td><p>Human readable microcode output file</td>
        </tr>
       </tbody>
    </table>
  </div>
</div>

