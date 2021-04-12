#define _XOPEN_SOURCE 600
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#define __USE_BSD
#include <termios.h>
#include <sys/select.h>
#include <sys/ioctl.h>
#include <string.h>

int main(void) {

    int fdm = posix_openpt(O_RDWR);
    if (fdm < 0) {
        perror("pty posix_openpt");
        return EXIT_FAILURE;
    }

    int ret = grantpt(fdm);
    if (ret != 0) {
        perror("pty posix_openpt");
        return EXIT_FAILURE;
    }

    ret = unlockpt(fdm);
    if (ret != 0) {
        perror("pty unlockpt");
        return EXIT_FAILURE;
    }

    //
    // Open PTY slave
    //  Get the slave name from the master.
    //

    int fds = open(ptsname(fdm), O_RDWR);

printf("fds = %d, fdm = %d\n", fds, fdm);

    //
    // Create the child process
    //

    if (fork()) {

        //
        // Parent
        //

        //
        // Close PTY slave
        //

        //close(fds);

        for (;;) {

            //
            // Wait for data from stdin and from PTY master
            //

            fd_set set;
            FD_ZERO(&set);
            FD_SET(STDIN_FILENO, &set);
            FD_SET(fdm, &set);

            int ret = select(FD_SETSIZE, &set, NULL, NULL, NULL);
            if (ret < 0) {
                exit(EXIT_FAILURE);
            }

            //
            // Data from stdin to PTY master
            //

            if (FD_ISSET(STDIN_FILENO, &set)) {
                char buf[1024];
                ssize_t bytes = read(STDIN_FILENO, buf, sizeof(buf));
                if (bytes > 0) {
                    write(fdm, buf, bytes);
                } else if (bytes < 0) {
                    perror("pty master write()");
                    exit(EXIT_FAILURE);
                }
            }

            //
            // Data from PTY master to stdout
            //

            if (FD_ISSET(fdm, &set)) {
                char buf[1024];
                ssize_t bytes = read(fdm, buf, sizeof(buf));
                if (bytes > 0) {
                    write(STDOUT_FILENO, buf, bytes);
                } else if (bytes < 0) {
                    perror("pty slave read()");
                    exit(EXIT_FAILURE);
                }
            }
        }

    } else {

        //
        // CHILD
        //

        //
        // Put the terminal in RAW mode.
        //

        struct termios settings;
        tcgetattr(fds, &settings);
        cfmakeraw(&settings);
        tcsetattr(fds, TCSANOW, &settings);

        //
        // Create new file descriptors.
        //

        close(STDIN_FILENO);
        close(STDOUT_FILENO);
        close(STDERR_FILENO);
        dup2(fds, STDIN_FILENO);
        dup2(fds, STDOUT_FILENO);
        dup2(fds, STDERR_FILENO);

        //
        // Close the original file descriptors.
        //

        close(fdm);
        close(fds);

        //
        // Make this process this new session leader and this the controlling
        // terminal
        //

        setsid();
        ioctl(STDIN_FILENO, TIOCSCTTY, 1);

        //
        // Start the terminal
        //

#if 0
        char * argv[] = {(char*)"mintty", NULL};
#else
        char * argv[] = {(char*)"xfce4-terminal", NULL};
#endif
        execvp(argv[0], argv);
        perror("pty slave execvp()");
    }

    return EXIT_FAILURE;
}
