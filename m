Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A992427A
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 23:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbfETVF0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 17:05:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47840 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfETVF0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 17:05:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KL3oo5046431
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 21:05:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=A9X0gJVzPSTb6WsRsmSYhcfFjdkUrqua58QMMRtmEF8=;
 b=pVudeVqIq7IUGgItYzzZQO9slw/Qbt8Ee8wJvJuxFcC+QWqdxFVPowJdtxjL8youKf2x
 wOugRl1wo+zwr7SsXiU0sCn8BoK1LxktfBakYuvdx2gBelTK1pav9qWqlFFJx9BOhw92
 soAomPpU7dWflo00FTfbxiKPJpvrml9XJSusY6Lf3siT5DTW0w8jSVEu5cZuhUKh50kt
 PgNKtwnmfqq0yhYucjis3LU6JoiaNf+ZptE6+ir4y5vvj4JYTbkU6rqw/Lw5hIjco8gU
 1RDJ5fZd5pytcW1eJ6ABjJqgeqADh/C2NK/bu1B40EVA7emUU50ogEt6DDsN42OGBhM3 ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sj9ft9k6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 21:05:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KL4Bxh080257
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 21:05:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sm046knap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 21:05:23 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KL5LI8027860
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 21:05:22 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 21:05:21 +0000
Date:   Mon, 20 May 2019 14:05:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_restore: refactor open-coded file creation code
Message-ID: <20190520210520.GB5335@magnolia>
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
 <155085404462.5141.11851529133557195388.stgit@magnolia>
 <463f5d1d-a13f-c489-1474-c0b8b3097a71@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463f5d1d-a13f-c489-1474-c0b8b3097a71@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200132
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 06, 2019 at 05:11:23PM -0700, Allison Collins wrote:
> On 2/22/19 9:47 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a helper to unlink, recreate, and reserve space in a file so that
> > we don't have two open-coded versions.  We lose the broken ALLOCSP code
> > since it never worked anyway.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >   restore/dirattr.c |   97 ++++++++++++++++++-----------------------------------
> >   restore/dirattr.h |    2 +
> >   restore/namreg.c  |   70 +++-----------------------------------
> >   3 files changed, 41 insertions(+), 128 deletions(-)
> > 
> > 
> > diff --git a/restore/dirattr.c b/restore/dirattr.c
> > index 5368664..0fb2877 100644
> > --- a/restore/dirattr.c
> > +++ b/restore/dirattr.c
> > @@ -55,6 +55,37 @@
> >   #include "openutil.h"
> >   #include "mmap.h"
> > +/* Create a file, try to reserve space for it, and return the fd. */
> > +int
> > +create_filled_file(
> > +	const char	*pathname,
> > +	off64_t		size)
> > +{
> > +	struct flock64	fl = {
> > +		.l_len = size,
> > +	};
> > +	int		fd;
> > +	int		ret;
> > +
> > +	(void)unlink(pathname);
> > +
> > +	fd = open(pathname, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);
> > +	if (fd < 0)
> > +		return fd;
> 
> Just a nit: I think if you goto done here instead of return, you can remove
> the extra goto below since it's not having much effect.  I sort of figured
> people like gotos because they like having one exit point to the function.
> Alternatively, if you don't mind having multiple exit points, you can simply
> return early in patch 4, and avoid the goto all together.

Hmm, you're right, let's just return fd directly instead of all this
goto nonsense.

--D

> Allison
> 
> > +
> > +	ret = ioctl(fd, XFS_IOC_RESVSP64, &fl);
> > +	if (ret && errno != ENOTTY)
> > +		mlog(MLOG_VERBOSE | MLOG_NOTE,
> > +_("attempt to reserve %lld bytes for %s using %s failed: %s (%d)\n"),
> > +				size, pathname, "XFS_IOC_RESVSP64",
> > +				strerror(errno), errno);
> > +	if (ret == 0)
> > +		goto done;
> > +
> > +done:
> > +	return fd;
> > +}
> > +
> >   /* structure definitions used locally ****************************************/
> >   /* node handle limits
> > @@ -238,13 +269,8 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
> >   			return BOOL_FALSE;
> >   		}
> >   	} else {
> > -		/* create the dirattr file, first unlinking any older version
> > -		 * laying around
> > -		 */
> > -		(void)unlink(dtp->dt_pathname);
> > -		dtp->dt_fd = open(dtp->dt_pathname,
> > -				   O_RDWR | O_CREAT | O_EXCL,
> > -				   S_IRUSR | S_IWUSR);
> > +		dtp->dt_fd = create_filled_file(dtp->dt_pathname,
> > +			DIRATTR_PERS_SZ + (dircnt * sizeof(struct dirattr)));
> >   		if (dtp->dt_fd < 0) {
> >   			mlog(MLOG_NORMAL | MLOG_ERROR, _(
> >   			      "could not create directory attributes file %s: "
> > @@ -253,63 +279,6 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
> >   			      strerror(errno));
> >   			return BOOL_FALSE;
> >   		}
> > -
> > -		/* reserve space for the backing store. try to use RESVSP64.
> > -		 * if doesn't work, try ALLOCSP64. the former is faster, as
> > -		 * it does not zero the space.
> > -		 */
> > -		{
> > -		bool_t successpr;
> > -		unsigned int ioctlcmd;
> > -		int loglevel;
> > -		size_t trycnt;
> > -
> > -		for (trycnt = 0,
> > -		      successpr = BOOL_FALSE,
> > -		      ioctlcmd = XFS_IOC_RESVSP64,
> > -		      loglevel = MLOG_VERBOSE
> > -		      ;
> > -		      ! successpr && trycnt < 2
> > -		      ;
> > -		      trycnt++,
> > -		      ioctlcmd = XFS_IOC_ALLOCSP64,
> > -		      loglevel = max(MLOG_NORMAL, loglevel - 1)) {
> > -			off64_t initsz;
> > -			struct flock64 flock64;
> > -			int rval;
> > -
> > -			if (! ioctlcmd) {
> > -				continue;
> > -			}
> > -
> > -			initsz = (off64_t)DIRATTR_PERS_SZ
> > -				 +
> > -				 ((off64_t)dircnt * sizeof(dirattr_t));
> > -			flock64.l_whence = 0;
> > -			flock64.l_start = 0;
> > -			flock64.l_len = initsz;
> > -			rval = ioctl(dtp->dt_fd, ioctlcmd, &flock64);
> > -			if (rval) {
> > -				if (errno != ENOTTY) {
> > -					mlog(loglevel | MLOG_NOTE, _(
> > -					      "attempt to reserve %lld bytes for %s "
> > -					      "using %s "
> > -					      "failed: %s (%d)\n"),
> > -					      initsz,
> > -					      dtp->dt_pathname,
> > -					      ioctlcmd == XFS_IOC_RESVSP64
> > -					      ?
> > -					      "XFS_IOC_RESVSP64"
> > -					      :
> > -					      "XFS_IOC_ALLOCSP64",
> > -					      strerror(errno),
> > -					      errno);
> > -				}
> > -			} else {
> > -				successpr = BOOL_TRUE;
> > -			}
> > -		}
> > -		}
> >   	}
> >   	/* mmap the persistent descriptor
> > diff --git a/restore/dirattr.h b/restore/dirattr.h
> > index dd37a98..e81e69c 100644
> > --- a/restore/dirattr.h
> > +++ b/restore/dirattr.h
> > @@ -88,4 +88,6 @@ extern bool_t dirattr_cb_extattr(dah_t dah,
> >   				  extattrhdr_t *ahdrp,
> >   				  void *ctxp);
> > +int create_filled_file(const char *pathname, off64_t size);
> > +
> >   #endif /* DIRATTR_H */
> > diff --git a/restore/namreg.c b/restore/namreg.c
> > index 89fa5ef..d0d5e89 100644
> > --- a/restore/namreg.c
> > +++ b/restore/namreg.c
> > @@ -37,6 +37,10 @@
> >   #include "namreg.h"
> >   #include "openutil.h"
> >   #include "mmap.h"
> > +#include "global.h"
> > +#include "content.h"
> > +#include "content_inode.h"
> > +#include "dirattr.h"
> >   /* structure definitions used locally ****************************************/
> > @@ -153,13 +157,8 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
> >   			return BOOL_FALSE;
> >   		}
> >   	} else {
> > -		/* create the namreg file, first unlinking any older version
> > -		 * laying around
> > -		 */
> > -		(void)unlink(ntp->nt_pathname);
> > -		ntp->nt_fd = open(ntp->nt_pathname,
> > -				   O_RDWR | O_CREAT | O_EXCL,
> > -				   S_IRUSR | S_IWUSR);
> > +		ntp->nt_fd = create_filled_file(ntp->nt_pathname,
> > +			NAMREG_PERS_SZ + (inocnt * NAMREG_AVGLEN));
> >   		if (ntp->nt_fd < 0) {
> >   			mlog(MLOG_NORMAL | MLOG_ERROR, _(
> >   			      "could not create name registry file %s: "
> > @@ -168,63 +167,6 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
> >   			      strerror(errno));
> >   			return BOOL_FALSE;
> >   		}
> > -
> > -		/* reserve space for the backing store. try to use RESVSP64.
> > -		 * if doesn't work, try ALLOCSP64. the former is faster, as
> > -		 * it does not zero the space.
> > -		 */
> > -		{
> > -		bool_t successpr;
> > -		unsigned int ioctlcmd;
> > -		int loglevel;
> > -		size_t trycnt;
> > -
> > -		for (trycnt = 0,
> > -		      successpr = BOOL_FALSE,
> > -		      ioctlcmd = XFS_IOC_RESVSP64,
> > -		      loglevel = MLOG_VERBOSE
> > -		      ;
> > -		      ! successpr && trycnt < 2
> > -		      ;
> > -		      trycnt++,
> > -		      ioctlcmd = XFS_IOC_ALLOCSP64,
> > -		      loglevel = max(MLOG_NORMAL, loglevel - 1)) {
> > -			off64_t initsz;
> > -			struct flock64 flock64;
> > -			int rval;
> > -
> > -			if (! ioctlcmd) {
> > -				continue;
> > -			}
> > -
> > -			initsz = (off64_t)NAMREG_PERS_SZ
> > -				 +
> > -				 ((off64_t)inocnt * NAMREG_AVGLEN);
> > -			flock64.l_whence = 0;
> > -			flock64.l_start = 0;
> > -			flock64.l_len = initsz;
> > -			rval = ioctl(ntp->nt_fd, ioctlcmd, &flock64);
> > -			if (rval) {
> > -				if (errno != ENOTTY) {
> > -					mlog(loglevel | MLOG_NOTE, _(
> > -					      "attempt to reserve %lld bytes for %s "
> > -					      "using %s "
> > -					      "failed: %s (%d)\n"),
> > -					      initsz,
> > -					      ntp->nt_pathname,
> > -					      ioctlcmd == XFS_IOC_RESVSP64
> > -					      ?
> > -					      "XFS_IOC_RESVSP64"
> > -					      :
> > -					      "XFS_IOC_ALLOCSP64",
> > -					      strerror(errno),
> > -					      errno);
> > -				}
> > -			} else {
> > -				successpr = BOOL_TRUE;
> > -			}
> > -		}
> > -		}
> >   	}
> >   	/* mmap the persistent descriptor
> > 
