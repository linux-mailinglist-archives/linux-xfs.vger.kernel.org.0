Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0D416639D
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Feb 2020 17:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgBTQ6s (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Feb 2020 11:58:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46356 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgBTQ6s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 11:58:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KGtQno034533;
        Thu, 20 Feb 2020 16:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5eX55A8BuJbogNBBAyGkhlbI4qJGz+3FyrWUvw+gdoU=;
 b=wLFIC4hdTCfQJCCUVRaTFOdCsVsrPTYVcdbxgN1HeryVJzezviuI3tVMcX57vrRjuQkX
 J/FZg8EJftiAew9njozWZ4fMpRqwMkmI/llHr/7hAADxhmvazOTK16cqUv71tfRuMefS
 z8D/w/7/TIV58bgLWFzvzlG0F6hd9GOTD+WBUmI4GBdCJslVIlFjLxWT9lQjN72+vIe3
 oY/iTkOOXaZZ3oe59uI2AEslzwYIuNS5J63ez8T1zKUYdzfrM0iH/Ntl0PGsei3Tkp+p
 FcO/C9udyTzt2J2fWTGGJXeGNba7+VkhenMZAzZwIpdp7Xyr/R+rSYplvQngLYKiWOQS Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2y8udkk46p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 16:58:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KGvogF158350;
        Thu, 20 Feb 2020 16:58:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2y8ud48g0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 16:58:42 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01KGwff2012796;
        Thu, 20 Feb 2020 16:58:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 08:58:41 -0800
Date:   Thu, 20 Feb 2020 08:58:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_db: check that metadata updates have been
 committed
Message-ID: <20200220165840.GX9506@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216293385.601264.3202158027072387776.stgit@magnolia>
 <20200220140623.GC48977@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220140623.GC48977@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200125
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 09:06:23AM -0500, Brian Foster wrote:
> On Wed, Feb 19, 2020 at 05:42:13PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new function that will ensure that everything we scribbled on has
> > landed on stable media, and report the results.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/init.c |   14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > 
> > diff --git a/db/init.c b/db/init.c
> > index 0ac37368..e92de232 100644
> > --- a/db/init.c
> > +++ b/db/init.c
> > @@ -184,6 +184,7 @@ main(
> >  	char	*input;
> >  	char	**v;
> >  	int	start_iocur_sp;
> > +	int	d, l, r;
> >  
> >  	init(argc, argv);
> >  	start_iocur_sp = iocur_sp;
> > @@ -216,6 +217,19 @@ main(
> >  	 */
> >  	while (iocur_sp > start_iocur_sp)
> >  		pop_cur();
> > +
> > +	libxfs_flush_devices(mp, &d, &l, &r);
> > +	if (d)
> > +		fprintf(stderr, _("%s: cannot flush data device (%d).\n"),
> > +				progname, d);
> > +	if (l)
> > +		fprintf(stderr, _("%s: cannot flush log device (%d).\n"),
> > +				progname, l);
> > +	if (r)
> > +		fprintf(stderr, _("%s: cannot flush realtime device (%d).\n"),
> > +				progname, r);
> > +
> > +
> 
> Seems like we could reduce some boilerplate by passing progname into
> libxfs_flush_devices() and letting it dump out of the error messages,
> unless there's some future code that cares about individual device error
> state.

Such a program could call libxfs_flush_devices directly, as we do here.

Also, progname is defined in libxfs so we don't even need to pass it as
an argument.

I had originally thought that we should try not to add fprintf calls to
libxfs because libraries aren't really supposed to be doing things like
that, but perhaps you're right that all of this should be melded into
something else.

> That said, it also seems the semantics of libxfs_flush_devices() are a
> bit different from convention. Just below we invoke
> libxfs_device_close() for each device (rather than for all three), and
> device_close() also happens to call fsync() and platform_flush_device()
> itself...

Yeah, the division of responsibilities is a little hazy here -- I would
think that unmounting a filesystem should flush all the memory caches
and then the disk cache, but OTOH it's the utility that opens the
devices and should therefore flush and close them.

I dunno.  My current thinking is that libxfs_umount should call
libxfs_flush_devices() and print error messages as necessary, and return
error codes as appropriate.  xfs_repair can then check the umount return
value and translate that into exit(1) as required.  The device_close
functions will fsync a second time, but that shouldn't be a big deal
because we haven't dirtied anything in the meantime.

Thoughts?

--D

> Brian
> 
> >  	libxfs_umount(mp);
> >  	if (x.ddev)
> >  		libxfs_device_close(x.ddev);
> > 
> 
