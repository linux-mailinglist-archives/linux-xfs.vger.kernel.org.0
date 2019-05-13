Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE8FB1BF09
	for <lists+linux-xfs@lfdr.de>; Mon, 13 May 2019 23:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfEMVNG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 May 2019 17:13:06 -0400
Received: from sandeen.net ([63.231.237.45]:57550 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfEMVNG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 May 2019 17:13:06 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7EEC015D72;
        Mon, 13 May 2019 16:12:50 -0500 (CDT)
Subject: Re: [PATCH] xfs_io: support splice data between two files
To:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org
References: <20190406023519.4429-1-zlang@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <3d20c179-1ed1-214c-c706-0cdfc4719629@sandeen.net>
Date:   Mon, 13 May 2019 16:13:04 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190406023519.4429-1-zlang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/5/19 9:35 PM, Zorro Lang wrote:
> Add splice command into xfs_io, by calling splice(2) system call.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> I've add splice() test into fsstress.c, due to we find a XFS regression
> by doing some splice test on overlayfs over XFS. Although copy_file_range
> maybe through splice() code path, but it depends. So a specified splice
> operation is helpful to use splice clearly.

Hi Zorro, I'm sorry this has gone so long w/o review.  Questions below.

> Thanks,
> Zorro
> 
>  io/Makefile       |   2 +-
>  io/init.c         |   1 +
>  io/io.h           |   1 +
>  io/splice.c       | 194 ++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_io.8 |  26 +++++++
>  5 files changed, 223 insertions(+), 1 deletion(-)
>  create mode 100644 io/splice.c
> 
> diff --git a/io/Makefile b/io/Makefile
> index 484e2b5a..06d21dd5 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -12,7 +12,7 @@ CFILES = init.c \
>  	attr.c bmap.c crc32cselftest.c cowextsize.c encrypt.c file.c freeze.c \
>  	fsync.c getrusage.c imap.c inject.c label.c link.c mmap.c open.c \
>  	parent.c pread.c prealloc.c pwrite.c reflink.c resblks.c scrub.c \
> -	seek.c shutdown.c stat.c swapext.c sync.c truncate.c utimes.c
> +	seek.c shutdown.c splice.c stat.c swapext.c sync.c truncate.c utimes.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
> diff --git a/io/init.c b/io/init.c
> index 83f08f2d..fc191aa7 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -79,6 +79,7 @@ init_commands(void)
>  	seek_init();
>  	sendfile_init();
>  	shutdown_init();
> +	splice_init();
>  	stat_init();
>  	swapext_init();
>  	sync_init();
> diff --git a/io/io.h b/io/io.h
> index 6469179e..9a0b71f0 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -110,6 +110,7 @@ extern void		quit_init(void);
>  extern void		resblks_init(void);
>  extern void		seek_init(void);
>  extern void		shutdown_init(void);
> +extern void		splice_init(void);
>  extern void		stat_init(void);
>  extern void		swapext_init(void);
>  extern void		sync_init(void);
> diff --git a/io/splice.c b/io/splice.c
> new file mode 100644
> index 00000000..7e2f1aa2
> --- /dev/null
> +++ b/io/splice.c
> @@ -0,0 +1,194 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2019 Red Hat, Inc.
> + * All Rights Reserved.
> + */
> +
> +#include "command.h"
> +#include "input.h"
> +#include <fcntl.h>
> +#include "init.h"
> +#include "io.h"
> +
> +static cmdinfo_t splice_cmd;
> +
> +static void
> +splice_help(void)
> +{
> +	printf(_(
> +"\n"
> +" Splice a range of bytes from the given offset between files through pipe\n"
> +"\n"
> +" Example:\n"
> +" 'splice filename 0 4096 32768' - splice 32768 bytes from filename at offset\n"
> +"                                  0 into the open file at position 4096\n"
> +" 'splice filename' - splice all bytes from filename into the open file at\n"
> +" '                   position 0\n"
> +"\n"
> +" Copies data between one file and another.  Because this copying is done\n"
> +" within the kernel, sendfile does not need to transfer data to and from user\n"
> +" space.\n"
> +" -m -- SPLICE_F_MOVE flag, attempt to move pages instead of copying.\n"
> +" Offset and length in the source/destination file can be optionally specified.\n"
> +"\n"));
> +}
> +
> +static uint64_t
> +splice_file(
> +	int		fd,
> +	off64_t		soffset,
> +	off64_t		doffset,
> +	size_t		length,
> +	unsigned int	flag,
> +	int		*ops)
> +{
> +	off64_t		soff = soffset;
> +	off64_t		doff = doffset;
> +	ssize_t		rc = 0;
> +	size_t		len = length;
> +	uint64_t	total = 0;
> +	int		filedes[2];
> +
> +	if (pipe(filedes) < 0) {
> +		perror("pipe");
> +		return -1;
> +	}
> +
> +	*ops = 0;
> +	while (len > 0 || !*ops) {
> +		/* move to pipe buffer */
> +		rc = splice(fd, &soff, filedes[1], NULL, len, flag);
> +		if (rc < 0) {
> +			perror("splice to pipe");
> +			goto out_close;
> +		}
> +		/* move from pipe buffer to dst file */
> +		rc = splice(filedes[0], NULL, file->fd, &doff, len, flag);
> +		if (rc < 0) {
> +			perror("splice from pipe");
> +			goto out_close;
> +		}
> +		(*ops)++;
> +		len -= rc;
> +		total += rc;
> +	}
> +
> +out_close:
> +	close(filedes[0]);
> +	close(filedes[1]);
> +	return total;
> +}
> +
> +static int
> +splice_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	off64_t		soffset, doffset;
> +	long long	count, total;
> +	size_t		blocksize, sectsize;
> +	struct timeval	t1, t2;
> +	char		*infile = NULL;
> +	int		Cflag, qflag;
> +	int		splice_flag = 0;
> +	int		c, fd = -1;
> +	int		ops = 0;
> +
> +	Cflag = qflag = 0;
> +	soffset = doffset=0;
> +	init_cvtnum(&blocksize, &sectsize);
> +
> +	while ((c = getopt(argc, argv, "Cqm")) != EOF) {
> +		switch (c) {
> +		case 'C':
> +			Cflag = 1;
> +			break;
> +		case 'q':
> +			qflag = 1;
> +			break;

-C and -q are not documented in the usage() output, but maybe that's
ok.  Looks like other callers of report_io_times skip that as well, so
maybe it's expected.

> +		case 'm':
> +			splice_flag |= SPLICE_F_MOVE;
> +			break;
> +		default:
> +			return command_usage(&splice_cmd);
> +		}
> +	}
> +
> +	if (optind != argc - 4 && optind != argc - 1)
> +		return command_usage(&splice_cmd);
> +
> +	infile = argv[optind];
> +	if ((fd = openfile(infile, NULL, IO_READONLY, 0, NULL)) < 0)
> +		return 0;
> +	optind++;
> +
> +	if (optind == argc - 3) {
> +		soffset = cvtnum(blocksize, sectsize, argv[optind]);
> +		if (soffset < 0) {
> +			printf(_("non-numeric src offset argument -- %s\n"), \
> +			       argv[optind]);
> +			return 0;
> +		}
> +		optind++;
> +		doffset = cvtnum(blocksize, sectsize, argv[optind]);
> +		if (doffset < 0) {
> +			printf(_("non-numeric dest offset argument -- %s\n"), \
> +			       argv[optind]);
> +			return 0;
> +		}
> +		optind++;
> +		count = cvtnum(blocksize, sectsize, argv[optind]);
> +		if (count < 0) {
> +			printf(_("non-positive length argument -- %s\n"), \
> +			       argv[optind]);
> +			return 0;

For the cvtnum errors, I think I would just say "invalid argument" -
and I'm not sure you can even specify a negative argument this way,
can you?  So the "non-positive" error message seems strange.

xfs_io> splice bar 0 0 -4
splice: invalid option -- '4'

also, I notice if "count" is greater than the size of one of (?) the files,
the command seems to hang.

Otherwise, this seems ok, thanks!
-Eric

> +		}
> +	} else {
> +		/*
> +		 * splice whole file to another, if doesn't specify src and dst
> +		 * offset and length
> +		 */
> +		struct stat	stat;
> +
> +		if (fstat(fd, &stat) < 0) {
> +			perror("fstat");
> +			goto done;
> +		}
> +		count = stat.st_size;
> +		soffset = 0;
> +		doffset = 0;
> +	}
> +
> +	gettimeofday(&t1, NULL);
> +	total = splice_file(fd, soffset, doffset, count, splice_flag, &ops);
> +	if (ops == 0 || qflag)
> +		goto done;
> +	gettimeofday(&t2, NULL);
> +	t2 = tsub(t2, t1);
> +
> +	report_io_times("spliced", &t2, (long long)doffset, count, total, ops, \
> +	                Cflag);
> +
> +done:
> +	if (infile)
> +		close(fd);
> +	return 0;
> +}
> +
> +void
> +splice_init(void)
> +{
> +	splice_cmd.name = "splice";
> +	splice_cmd.altname = "spl";
> +	splice_cmd.cfunc = splice_f;
> +	splice_cmd.argmin = 1;
> +	splice_cmd.argmax = -1;
> +	splice_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;;
> +	splice_cmd.args =
> +		_("[-m] infile [src_off dst_off len]");
> +	splice_cmd.oneline =
> +		_("Splice an entire file, or a number of bytes at a specified offset");
> +	splice_cmd.help = splice_help;
> +
> +	add_command(&splice_cmd);
> +}
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 980dcfd3..066a72e7 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -830,6 +830,32 @@ verbose output will be printed.
>  .RE
>  .PD
>  .TP
> +.BI "splice  [ \-C ] [ \-q ] [\-m] infile [src_offset dst_offset length]"
> +On filesystems that support the
> +.BR splice (2)
> +system call, splice data from the
> +.I infile
> +into the open file. If
> +.IR src_offset ,
> +.IR dst_offset ,
> +and
> +.I length
> +are omitted the contents of infile will be copied to the beginning of the
> +open file, overwriting any data already there.
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.B \-C
> +Print timing statistics in a condensed format.
> +.TP
> +.B \-q
> +Do not print timing statistics at all.
> +.TP
> +.B \-m
> +Enable SPLICE_F_MOVE flag, attempt to move pages instead of copying.
> +.RE
> +.PD
> +.TP
>  .BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec"
>  The utimes command changes the atime and mtime of the current file.
>  sec uses UNIX timestamp notation and is the seconds elapsed since
> 
