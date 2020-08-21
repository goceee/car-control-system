#include <iostream>
#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <termios.h> /* POSIX terminal control */
#include <cstdlib>
using namespace std;

int open_port();

int main()
{
	int fd = 0;
    	struct termios options;
    	fd = open_port();
	tcgetattr(fd, &options);
	int rc;
	int dutyS;
	int dutyA;
	char option;
	 // Get the attributes
	 if((rc = tcgetattr(fd, &options)) < 0){
        fprintf(stderr, "failed to get attr: %d, %s\n", fd, strerror(errno));
        exit(EXIT_FAILURE);
    }

	cfmakeraw(&options);
    	options.c_cflag |= (B9600 | CS8 | CLOCAL | CREAD);   // Enable the receiver and set local mode
    	options.c_cflag &= ~CSTOPB;            // 1 stop bit
    	options.c_cflag &= ~CRTSCTS;           // Disable hardware flow control
    	options.c_cc[VMIN]  = 1;
    	options.c_cc[VTIME] = 2;

	// Set the new attributes
    	if((rc = tcsetattr(fd, TCSANOW, &options)) < 0){
        fprintf(stderr, "failed to set attr: %d, %s\n", fd, strerror(errno));
        exit(EXIT_FAILURE);
    }
	//SPEED OR ANGLE SELECTION 
	cout << "Select s for speed, a for angle, q to stop, c to close " << endl;
	cin  >> option;
	do{
	if (option == 's'){
	cout << "Writing for s " << endl;
	write(fd, &option, 1);
	cout << "Enter speed between 0 and 200: " << endl;
	cin  >> dutyS;
		while (dutyS > 200 || dutyS < 0) {
		cout << "Enter speed between 0 and 200: " << endl;
		cin  >> dutyS;
		}
	//cout << "Writing for dutySpeed " << endl;
	write(fd, &dutyS, 1);
	cout << "Select s for speed, a for angle, q to stop, c to close " << endl;
	cin  >> option;
	}
	else if (option == 'a'){
	cout << "Writing for a " << endl;
	write (fd, &option, 1);
	cout << "Enter angle between 0 and 200, 100 is middle: " << endl;
	cin  >> dutyA;
		while (dutyA < 0 || dutyA > 200){
		cout << "Enter angle between 0 and 200, 100 is middle: " << endl;
		cin  >> dutyA;
}
	//cout << "Writing duty cycle Angle " << endl;
	write(fd, &dutyA, 1);
	cout << "Select s for speed, a for angle, q to stop, c to close " << endl;
	cin  >> option;
	}
	else if (option == 'q'){
	write (fd, &option, 1);
	cout << "Car stopped" << endl;
	cout << "Select s for speed, a for angle, q to stop, c to close " << endl;
	cin  >> option;}
	while (option != 's' && option != 'a' && option != 'q' && option != 'c'){
	cout << "Select s for speed, a for angle, q to stop, c to close " << endl;
	cin  >> option;}
}while(option != 'c');
	cout << "Connection stopped " << endl;
	close(fd);
    	return 0;
}


int open_port()
{
  int fd; /* File descriptor for the port */


  fd = open("/dev/ttyS12", O_RDWR | O_NOCTTY | O_NDELAY);
  if (fd == -1)
  {
   /*
    * Could not open the port.
    */

    perror("open_port: Unable to open /dev/ttyS12 - ");
  }
  else
    fcntl(fd, F_SETFL, 0);

  return (fd);
}
