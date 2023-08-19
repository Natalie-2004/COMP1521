#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <grp.h>
#include <pwd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

char *rwxmode (mode_t);
char *username (uid_t);
char *groupname (gid_t);
char *gettime(time_t);

int main (int argc, char **argv)
{
    struct stat info;

    if (argc == 1)
        if (stat(".", &info) == -1) perror("stat");
        else {
            char *rwx_str = rwxmode(info.st_mode);
            char *uname_str = username(info.st_uid);
            char *gname_str = groupname(info.st_gid);
            char *time_str = gettime(info.st_mtime);

            printf ("%s %lu %s %s %ld %s %s\n",
                rwx_str,
                info.st_nlink,
                uname_str,
                gname_str,
                info.st_size,
                time_str,
                "."
            );
            free(rwx_str);
            free(uname_str);
            free(gname_str);
            free(time_str);
        }
    else for (int i = 1; i < argc; i++)
        if (stat(argv[i], &info) == -1) perror("stat");
        else {
            char *rwx_str = rwxmode(info.st_mode);
            char *uname_str = username(info.st_uid);
            char *gname_str = groupname(info.st_gid);
            char *time_str = gettime(info.st_mtime);

            printf ("%s %lu %s %s %ld %s %s\n",
                rwx_str,
                info.st_nlink,
                uname_str,
                gname_str,
                info.st_size,
                time_str,
                argv[i]
            );
            free(rwx_str);
            free(uname_str);
            free(gname_str);
            free(time_str);
        }
    return EXIT_SUCCESS;
}

// convert octal mode to -rwxrwxrwx string
char *rwxmode (mode_t mode)
{
    char *perms = calloc(11, sizeof(char));

    switch (mode & S_IFMT) {
        case S_IFREG: perms[0] = '-'; break;
        case S_IFDIR: perms[0] = 'd'; break;
        case S_IFLNK: perms[0] = 'l'; break;
        default:      perms[0] = '?'; break;
    }

    perms[1]  = (mode & S_IRUSR) ? 'r' : '-';
    perms[2]  = (mode & S_IWUSR) ? 'w' : '-';
    perms[3]  = (mode & S_IXUSR) ? 'x' : '-';
    perms[4]  = (mode & S_IRGRP) ? 'r' : '-';
    perms[5]  = (mode & S_IWGRP) ? 'w' : '-';
    perms[6]  = (mode & S_IXGRP) ? 'x' : '-';
    perms[7]  = (mode & S_IROTH) ? 'r' : '-';
    perms[8]  = (mode & S_IWOTH) ? 'w' : '-';
    perms[9]  = (mode & S_IXOTH) ? 'x' : '-';
    perms[10] = '\0';

    return perms;
}

// convert user id to user name
char *username (uid_t uid)
{
    char *uname = NULL;

    struct passwd uinfo, *result;
    char *buf;
    long bufsize;

    bufsize = sysconf(_SC_GETPW_R_SIZE_MAX);
    if (bufsize == -1) bufsize = 1024;

    buf = alloca(bufsize);
    if (buf == NULL) {
        perror("alloca");
        exit(EXIT_FAILURE);
    }

    getpwuid_r(uid, &uinfo, buf, bufsize, &result);

    if (result != NULL) {
        uname = realloc(uname, snprintf (NULL, 0, "%s", uinfo.pw_name) + 1);
        sprintf(uname, "%s", uinfo.pw_name);
    } else {
        uname = realloc(uname, snprintf (NULL, 0, "%d?", (int)uid) + 1);
        sprintf(uname, "%d?", (int)uid);
    }

    return uname;
}

// convert group id to group name
char *groupname (gid_t gid)
{
    char *gname = NULL;

    struct group ginfo, *result;
    char *buf;
    long bufsize;

    bufsize = sysconf(_SC_GETGR_R_SIZE_MAX);
    if (bufsize == -1) bufsize = 1024;

    buf = alloca(bufsize);
    if (buf == NULL) {
        perror("alloca");
        exit(EXIT_FAILURE);
    }

    getgrgid_r(gid, &ginfo, buf, bufsize, &result);

    if (result != NULL) {
        gname = realloc(gname, snprintf(NULL, 0, "%s", ginfo.gr_name) + 1);
        sprintf(gname, "%s", ginfo.gr_name);
    } else {
        gname = realloc(gname, snprintf(NULL, 0, "%d?", (int)gid) + 1);
        sprintf(gname, "%d?", (int)gid);
    }

    return gname;
}

char *gettime(time_t file_time)
{
#define TIME_SIZE 128
    char *time_str = calloc(TIME_SIZE, sizeof(char));

    time_t now = time(NULL);
    struct tm tm_file, tm_now;

    localtime_r(&file_time, &tm_file);
    localtime_r(&now, &tm_now);

    if (tm_file.tm_year == tm_now.tm_year) { /* if year is current output date/time */
        // strftime has no way of returning length like snprintf(3) does;
        // time_str = realloc(time_str, strftime(NULL, 0, "%b %e %H:%M", &tm_file));
        strftime(time_str, TIME_SIZE, "%b %e %H:%M", &tm_file);
    } else { /* if year is not current, output time/year */
        // strftime has no way of returning length like snprintf(3) does;
        // time_str = realloc(time_str, strftime(NULL, 0, "%b %e %Y", &tm_file));
        strftime(time_str, TIME_SIZE, "%b %e %Y", &tm_file);
    }

    return time_str;
#undef TIME_SIZE
}