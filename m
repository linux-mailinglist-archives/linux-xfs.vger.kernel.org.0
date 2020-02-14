Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8089815CF7D
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Feb 2020 02:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgBNBfG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Feb 2020 20:35:06 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45439 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728052AbgBNBfG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Feb 2020 20:35:06 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6635443FF4B;
        Fri, 14 Feb 2020 12:34:57 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j2Psf-0004qp-3e; Fri, 14 Feb 2020 12:34:57 +1100
Date:   Fri, 14 Feb 2020 12:34:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] libxfs: use FALLOC_FL_ZERO_RANGE in libxfs_device_zero
Message-ID: <20200214013457.GX10776@dread.disaster.area>
References: <4bc3be27-b09d-a708-f053-6f7240642667@sandeen.net>
 <3ebe2d29-7943-b0a2-db5c-196610537bca@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ebe2d29-7943-b0a2-db5c-196610537bca@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=dpQr-ZrC_PExVuCaDwsA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 13, 2020 at 07:05:50PM -0600, Eric Sandeen wrote:
> I had a request from someone who cared about mkfs speed(!)
> over a slower network block device to look into using faster
> zeroing methods, particularly for the log, during mkfs.
> 
> Using FALLOC_FL_ZERO_RANGE is faster in this case than writing
> a bunch of zeros across a wire.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Clean up all the nasty stuff I'd flung out there as a wild first
> cut, thanks Dave.
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 4700b527..1dd27f76 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -144,6 +144,9 @@ endif
>  ifeq ($(HAVE_GETFSMAP),yes)
>  PCFLAGS+= -DHAVE_GETFSMAP
>  endif
> +ifeq ($(HAVE_FALLOCATE),yes)
> +PCFLAGS += -DHAVE_FALLOCATE
> +endif
>  
>  LIBICU_LIBS = @libicu_LIBS@
>  LIBICU_CFLAGS = @libicu_CFLAGS@
> diff --git a/include/linux.h b/include/linux.h
> index 8f3c32b0..8d5c4584 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -20,6 +20,10 @@
>  #include <stdio.h>
>  #include <asm/types.h>
>  #include <mntent.h>
> +#include <fcntl.h>
> +#if defined(HAVE_FALLOCATE)
> +#include <linux/falloc.h>
> +#endif
>  #ifdef OVERRIDE_SYSTEM_FSXATTR
>  # define fsxattr sys_fsxattr
>  #endif
> @@ -164,6 +168,24 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
>  	endmntent(cursor->mtabp);
>  }
>  
> +#if defined(FALLOC_FL_ZERO_RANGE)
> +static inline int
> +platform_zero_range(
> +	int		fd,
> +	xfs_off_t	start,
> +	size_t		len)
> +{
> +	int ret;
> +
> +	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
> +	if (!ret)
> +		return 0;
> +	return -errno;
> +}
> +#else
> +#define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
> +#endif

That all looks good. :)

>  /*
>   * Check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves. These
>   * are a copy of the definitions moved to linux/uapi/fs.h in the 4.5 kernel,
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 0d9d7202..2f6a3eb3 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -60,9 +60,19 @@ int
>  libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  {
>  	xfs_off_t	start_offset, end_offset, offset;
> -	ssize_t		zsize, bytes;
> +	ssize_t		zsize, bytes, len_bytes;

len_bytes should be size_t, right?

>  	char		*z;
> -	int		fd;
> +	int		error, fd;
> +
> +	fd = libxfs_device_to_fd(btp->dev);
> +	start_offset = LIBXFS_BBTOOFF64(start);
> +	end_offset = LIBXFS_BBTOOFF64(start + len) - start_offset;
> +
> +	/* try to use special zeroing methods, fall back to writes if needed */
> +	len_bytes = LIBXFS_BBTOOFF64(len);
> +	error = platform_zero_range(fd, start_offset, len_bytes);

This is a bit ... convoluted, and doesn't end_offset = len_bytes?
i.e.

start_offset = start << BBSHIFT
len_bytes = len << BBSHIFT
end_offset = (start + len) << BBSHIFT - start_offset
	   = (start << BBSHIFT) + (len << BBSHIFT) - start_offset
	   = start_offset + len_bytes - start_offset
	   = len_bytes

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
