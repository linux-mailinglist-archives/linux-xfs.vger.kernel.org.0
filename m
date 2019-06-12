Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCF842BEE
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 18:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfFLQS1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 12:18:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43090 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfFLQS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 12:18:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5CGHQ6d156467;
        Wed, 12 Jun 2019 16:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=pG2uSLNz/LnL3kQ1QG1EPMYa7NeF2BzZoYhxoZcCwts=;
 b=A1lZTq20hH5l4Ue+ejOTuBKyDmOSYQRIDTHfJ15huaACThI+mtMMfdy8VtzzszbmAd48
 Zs2e92udrJskh7yusjBV9VMU6urEDBnHYHoZusm3M9FP8ANuIZtql7EyaqoOW5dIr9oE
 6xalaiR0KR3PMGGRX8DCww8EwcdmVUcs4t1RK3eH9OOI8EFusaJG9OF6l+xD8zFtTkP8
 oStHSkL7Kj8rSWTfudMzc4sPuWGUvongEy3h5WDaN4XF9Qt9HJ8uvIjGJSErmiDql84S
 H9PIomUxM30yebpKg0dasqiwUEG4w1ANQI1Moytg2ddF+C+qxt7q6za824gmSXkOUFwH Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t04etvnrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 16:17:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5CGGCuO067493;
        Wed, 12 Jun 2019 16:17:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2t0p9ry439-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 16:17:45 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5CGHjLg027803;
        Wed, 12 Jun 2019 16:17:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Jun 2019 09:17:45 -0700
Date:   Wed, 12 Jun 2019 09:17:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: show build options in sysfs
Message-ID: <20190612161744.GD3773859@magnolia>
References: <97e16da4-e5ad-3049-0f6b-c1e24462e035@redhat.com>
 <20190607132057.GD57123@bfoster>
 <08f400d3-47e8-77bd-3685-d230e9ff49bd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08f400d3-47e8-77bd-3685-d230e9ff49bd@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 07, 2019 at 08:41:09AM -0500, Eric Sandeen wrote:
> On 6/7/19 8:20 AM, Brian Foster wrote:
> > On Thu, Jun 06, 2019 at 10:30:09PM -0500, Eric Sandeen wrote:
> >> This adds the "build options" string to a sysfs entry:
> >>
> >> # cat /sys/fs/xfs/features/build_opts 
> >> ACLs, security attributes, realtime, scrub, no debug
> >>
> >> because right now we only get it in dmesg and scraping dmesg
> >> is not a great option.
> >>
> >> This is really /build options/, not features as in "on-disk,
> >> superblock features" like XFS_SB_FEAT_* - putting this under a
> >> features/ dir will leave the window open open to do supported
> >> superblock features ala ext4 & f2fs in the future if desired.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> No sure if it would make sense to have i.e.
> >>
> >> /sys/fs/xfs/features/build_options
> >> /sys/fs/xfs/features/finobt
> >> /sys/fs/xfs/features/rmapbt
> >> ...
> >>
> >> all in the same features/ dir ?
> >>
> > 
> > What's the purpose of the features dir, and why an entry per feature as
> > opposed to a single 'features' file like we're adding for build_opts?
> 
> just because ext4 and f2fs did it that way, and supposedly sysfs
> is one value per file.
> 
> also our entire sysfs structure is based around having dirs under xfs/
> - tbh I haven't yet sorted out how to actually ad a bare file under
> xfs/ ;)  Of course it's possible but existing infra in our code is friendlier
> with subdirs of files.  ;)

sysfs_create_file(&xfs_kset.kobj, ATTR_LIST(build_opts)); ?

sysfs is such a pain... I'm pretty sure that's a gross hack since a kset
doesn't look like it's supposed to have attributes.

> 
> > Would those per-feature files present any data? The patch seems
> > reasonable to me in general, but I'd prefer to see the directory
> > structure thing at least hashed out before we decide on this kind of
> > placement (as opposed to something like /sys/fs/xfs/build_opts, if that
> > is possible).
> 
> Yeah, that's why I raised the question above, stupid me ;)
> 
> > I see that ext4 has a per-file feature dir along these lines:
> > 
> > $ ls /sys/fs/ext4/features/
> > batched_discard  encryption  lazy_itable_init  meta_bg_resize  metadata_csum_seed
> > $ cat /sys/fs/ext4/features/*
> > supported
> > supported
> > supported
> > supported
> > supported
> > 
> > I'm not sure if those files disappear when a feature is not available or
> > persist and return something other than "supported?" Are those files
> > used by anything in userspace?
> 
> It's based on what the running code can support, i.e. the total of its
> COMPAT_FEATURES stuff.

If you do, can we please build a feature flags to strings decoder ring
so that xfs_db/kernel/mkfs/repair can standardize the names for all the
features?  I'd like to avoid the spinodes/sparse confusion again.

--D

> 
> >> Also I didn't test module unload/teardown as I'm testing on xfs root.
> >>
> > 
> > insmod/rmmod works on a quick test on one of my VMs.
> 
> thanks, sorry for being lazy there.
> 
> -Eric
> 
> > Brian
> > 
> >> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >> index a14d11d78bd8..bc0e7fd63567 100644
> >> --- a/fs/xfs/xfs_super.c
> >> +++ b/fs/xfs/xfs_super.c
> >> @@ -55,9 +55,10 @@
> >>  static const struct super_operations xfs_super_operations;
> >>  struct bio_set xfs_ioend_bioset;
> >>  
> >> -static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
> >> +static struct kset *xfs_kset;			/* top-level xfs sysfs dir */
> >> +static struct xfs_kobj xfs_features_kobj;	/* global features */
> >>  #ifdef DEBUG
> >> -static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
> >> +static struct xfs_kobj xfs_dbg_kobj;		/* global debug sysfs attrs */
> >>  #endif
> >>  
> >>  /*
> >> @@ -2134,11 +2135,16 @@ init_xfs_fs(void)
> >>  	if (error)
> >>  		goto out_free_stats;
> >>  
> >> +	xfs_features_kobj.kobject.kset = xfs_kset;
> >> +	error = xfs_sysfs_init(&xfs_features_kobj, &xfs_features_ktype,
> >> +				NULL, "features");
> >> +	if (error)
> >> +		goto out_remove_stats_kobj;
> >>  #ifdef DEBUG
> >>  	xfs_dbg_kobj.kobject.kset = xfs_kset;
> >>  	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
> >>  	if (error)
> >> -		goto out_remove_stats_kobj;
> >> +		goto out_remove_features_kobj;
> >>  #endif
> >>  
> >>  	error = xfs_qm_init();
> >> @@ -2155,8 +2161,10 @@ init_xfs_fs(void)
> >>   out_remove_dbg_kobj:
> >>  #ifdef DEBUG
> >>  	xfs_sysfs_del(&xfs_dbg_kobj);
> >> - out_remove_stats_kobj:
> >> + out_remove_features_kobj:
> >>  #endif
> >> +	xfs_sysfs_del(&xfs_features_kobj);
> >> + out_remove_stats_kobj:
> >>  	xfs_sysfs_del(&xfsstats.xs_kobj);
> >>   out_free_stats:
> >>  	free_percpu(xfsstats.xs_stats);
> >> @@ -2186,6 +2194,7 @@ exit_xfs_fs(void)
> >>  #ifdef DEBUG
> >>  	xfs_sysfs_del(&xfs_dbg_kobj);
> >>  #endif
> >> +	xfs_sysfs_del(&xfs_features_kobj);
> >>  	xfs_sysfs_del(&xfsstats.xs_kobj);
> >>  	free_percpu(xfsstats.xs_stats);
> >>  	kset_unregister(xfs_kset);
> >> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> >> index cabda13f3c64..98f36ad16237 100644
> >> --- a/fs/xfs/xfs_sysfs.c
> >> +++ b/fs/xfs/xfs_sysfs.c
> >> @@ -222,6 +222,28 @@ struct kobj_type xfs_dbg_ktype = {
> >>  
> >>  #endif /* DEBUG */
> >>  
> >> +/* features */
> >> +
> >> +STATIC ssize_t
> >> +build_opts_show(
> >> +	struct kobject	*kobject,
> >> +	char		*buf)
> >> +{
> >> +	return snprintf(buf, PAGE_SIZE, "%s\n", XFS_BUILD_OPTIONS);
> >> +}
> >> +XFS_SYSFS_ATTR_RO(build_opts);
> >> +
> >> +static struct attribute *xfs_features_attrs[] = {
> >> +	ATTR_LIST(build_opts),
> >> +	NULL,
> >> +};
> >> +
> >> +struct kobj_type xfs_features_ktype = {
> >> +	.release = xfs_sysfs_release,
> >> +	.sysfs_ops = &xfs_sysfs_ops,
> >> +	.default_attrs = xfs_features_attrs,
> >> +};
> >> +
> >>  /* stats */
> >>  
> >>  static inline struct xstats *
> >> diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
> >> index e9f810fc6731..e475f6b7eb91 100644
> >> --- a/fs/xfs/xfs_sysfs.h
> >> +++ b/fs/xfs/xfs_sysfs.h
> >> @@ -11,6 +11,7 @@ extern struct kobj_type xfs_mp_ktype;	/* xfs_mount */
> >>  extern struct kobj_type xfs_dbg_ktype;	/* debug */
> >>  extern struct kobj_type xfs_log_ktype;	/* xlog */
> >>  extern struct kobj_type xfs_stats_ktype;	/* stats */
> >> +extern struct kobj_type xfs_features_ktype;	/* features*/
> >>  
> >>  static inline struct xfs_kobj *
> >>  to_kobj(struct kobject *kobject)
> >>
> 
