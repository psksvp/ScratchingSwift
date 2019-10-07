/*
*  The BSD 3-Clause License
*  Copyright (c) 2018. by Pongsak Suvanpong (psksvp@gmail.com)
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification,
*  are permitted provided that the following conditions are met:
*
*  1. Redistributions of source code must retain the above copyright notice,
*  this list of conditions and the following disclaimer.
*
*  2. Redistributions in binary form must reproduce the above copyright notice,
*  this list of conditions and the following disclaimer in the documentation
*  and/or other materials provided with the distribution.
*
*  3. Neither the name of the copyright holder nor the names of its contributors may
*  be used to endorse or promote products derived from this software without
*  specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
*  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
*  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
*  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
*  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
*  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* This information is provided for personal educational purposes only.
*
* The author does not guarantee the accuracy of this information.
*
* By using the provided information, libraries or software, you solely take the risks of damaging your hardwares.
*/

#include "include/LinuxInput.h"
#include <fcntl.h>
#include <stdio.h>
#include <linux/joystick.h>
#include <fcntl.h>
#include <unistd.h>
#include <poll.h>

////////
int joystickOpen(const char* path)
{
  return open(path, O_RDONLY|O_NONBLOCK);
}

void joystickClose(int fd)
{
  if(-1 != fd)
    close(fd);
}

int joystickControlButtonConst()
{
  return JS_EVENT_BUTTON;
}

int joystickConteolAxisConst()
{
  return JS_EVENT_AXIS;
}

unsigned int joystickAxisCount(int fd)
{
  __u8 axes;

  if (ioctl(fd, JSIOCGAXES, &axes) == -1)
    return 0;

  return (unsigned int)axes;
}

unsigned int joystickButtonCount(int fd)
{
  __u8 buttons;
  if (ioctl(fd, JSIOCGBUTTONS, &buttons) == -1)
    return 0;

  return (unsigned int)buttons;
}

struct JoystickData joystickRead(int fd, unsigned int msTimeout)
{
  struct JoystickData jsd;
  jsd.valid = 0;
  
  struct pollfd fds[1];
  fds[0].fd = fd;
  fds[0].events = POLLIN;
  
  if( poll(fds, 1, msTimeout) > 0 )
  {
    struct js_event event;
    ssize_t bytes = read(fd, &event, sizeof(event));

    if (bytes == sizeof(event))
    {
      jsd.valid = 1;
      jsd.type = event.type;
      jsd.controlID = event.number;
      jsd.value = event.value;
    }
   }
   
   return jsd;
}

