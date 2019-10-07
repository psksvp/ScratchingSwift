
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


///**
// * Reads a joystick event from the joystick device.
// *
// * Returns 0 on success. Otherwise -1 is returned.
// */
//int read_event(int fd, struct js_event *event)
//{
//    ssize_t bytes;
//
//    bytes = read(fd, event, sizeof(*event));
//
//    if (bytes == sizeof(*event))
//        return 0;
//
//    /* Error, could not read full event. */
//    return -1;
//}
//
///**
// * Current state of an axis.
// */
//struct axis_state {
//    short x, y;
//};
//
///**
// * Keeps track of the current axis state.
// *
// * NOTE: This function assumes that axes are numbered starting from 0, and that
// * the X axis is an even number, and the Y axis is an odd number. However, this
// * is usually a safe assumption.
// *
// * Returns the axis that the event indicated.
// */
//size_t get_axis_state(struct js_event *event, struct axis_state axes[10])
//{
//    size_t axis = event->number / 2;
//
//    if (axis < 10)
//    {
//        if (event->number % 2 == 0)
//            axes[axis].x = event->value;
//        else
//            axes[axis].y = event->value;
//    }
//
//    return axis;
//}
//
//int test(int argc, char *argv[])
//{
//    const char *device;
//    int js;
//    struct js_event event;
//    struct axis_state axes[10] = {0};
//    size_t axis;
//
//    if (argc > 1)
//        device = argv[1];
//    else
//        device = "/dev/input/js0";
//
//    js = open(device, O_RDONLY);
//
//    if (js == -1)
//        perror("Could not open joystick");
//    else
//    {
//      printf("axis count -> %d\n", get_axis_count(js));
//      printf("buttons count -> %d\n", get_button_count(js));
//    }
//
//    /* This loop will exit if the controller is unplugged. */
//    while (read_event(js, &event) == 0)
//    {
//        switch (event.type)
//        {
//            case JS_EVENT_BUTTON:
//                printf("Button %u %s\n", event.number, event.value ? "pressed" : "released");
//                break;
//            case JS_EVENT_AXIS:
//                //axis = get_axis_state(&event, axes);
//                //if (axis < 3)
//                //printf("Axis %zu at (%6d, %6d)\n", axis, axes[axis].x, axes[axis].y);
//                 printf("Axis %u %d\n", event.number, event.value);
//                break;
//            case JS_EVENT_INIT:
//                printf("init..\n");
//            default:
//                /* Ignore init events. */
//                break;
//        }
//    }
//
//    close(js);
//    return 0;
//}


// #include <linux/input.h>
// #include <stdio.h>
// #include <fcntl.h>
// #include <unistd.h>
// #include <poll.h>
//
// int main(int argc, char *argv[])
// {
//     int timeout_ms = 5000;
//     char* input_dev = argv[1];
//     int st;
//     int ret;
//     struct pollfd fds[1];
//
//     fds[0].fd = open(input_dev, O_RDONLY|O_NONBLOCK);
//
//     if(fds[0].fd<0)
//     {
//         printf("error unable open for reading '%s'\n",input_dev);
//         return(0);
//     }
//
//     struct input_event e;
//
//     fds[0].events = POLLIN;
//
//     int exit_on_key_press_count = 10;
//
//     while(1)
//     {
//         ret = poll(fds, 1, timeout_ms);
//
//         if(ret>0)
//         {
//             if(fds[0].revents)
//             {
//                 ssize_t r = read(fds[0].fd, &e, sizeof(e));
//
//                 if(r<0)
//                 {
//                     printf("error %d\n",(int)r);
//                     break;
//                 }
//                 else
//                 {
//                   printf("%hu %hu %u\n", e.type, e.code, e.value);
//                 }
//             }
//             else
//             {
//                 printf("error\n");
//             }
//         }
//         else
//         {
//             printf("timeout\n");
//         }
//     }
//
//     close(fds[0].fd);
//     return 0;
//   }

