# Common System Services for x86_64 Ubuntu

| Syscall Number | System Call          | Purpose                                           | Description                                       |
|----------------|----------------------|---------------------------------------------------|---------------------------------------------------|
| 1              | `write`              | Write to a file descriptor                        | Writes data to the specified file descriptor.     |
| 2              | `fork`               | Create a new process                              | Duplicates the current process.                    |
| 3              | `read`               | Read from a file descriptor                       | Reads data from the specified file descriptor.    |
| 60             | `exit`               | Terminate a process                               | Exits the program with a specified exit status.   |
| 5              | `open`               | Open a file                                      | Opens a file and returns a file descriptor.       |
| 6              | `close`              | Close a file descriptor                           | Closes the specified file descriptor.             |
| 9              | `mmap`               | Map files or devices into memory                 | Maps a file or device into the process's address space. |
| 59             | `execve`             | Execute a program                                | Executes the specified program.                    |
| 37             | `kill`               | Send a signal to a process                       | Sends a signal to a specific process.              |
| 122            | `uname`              | Get system information                           | Retrieves system details.                          |

## Example Description of System Calls

- **write**: Used to send data to a file or standard output. It takes a file descriptor and a buffer of data to write.
- **fork**: Creates a duplicate of the current process, useful for multitasking.
- **read**: Reads data from a specified file descriptor into a buffer.
- **exit**: Terminates the program and returns a status code to the operating system.
- **open**: Opens a file and returns a file descriptor, allowing access to the file.
- **close**: Closes an open file descriptor to free up resources.
- **mmap**: Maps files or devices into memory for easier access.
- **execve**: Replaces the current process image with a new program.
- **kill**: Sends a specified signal to a process to control it
