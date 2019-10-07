#ifndef __LINUX_INPUT_SWIFT_MOD__
#define __LINUX_INPUT_SWIFT_MOD__


struct JoystickData
{
  int valid;
  int type;
  int controlID;
  int value;
};

int joystickOpen(const char* path);
void joystickClose(int fd);
int joystickControlButtonConst();
int joystickConteolAxisConst();
unsigned int joystickAxisCount(int fd);
unsigned int joystickButtonCount(int fd);
struct JoystickData joystickRead(int fd, unsigned int msTimeout);

#endif
