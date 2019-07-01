Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4C038BD3
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 15:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbfFGNlN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 09:41:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34670 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbfFGNlM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jun 2019 09:41:12 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 126FD2E95B8
        for <linux-xfs@vger.kernel.org>; Fri,  7 Jun 2019 13:41:12 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80F4663BB1;
        Fri,  7 Jun 2019 13:41:10 +0000 (UTC)
Subject: Re: [PATCH] xfs: show build options in sysfs
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <97e16da4-e5ad-3049-0f6b-c1e24462e035@redhat.com>
 <20190607132057.GD57123@bfoster>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <08f400d3-47e8-77bd-3685-d230e9ff49bd@redhat.com>
Date:   Fri, 7 Jun 2019 08:41:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190607132057.GD57123@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 07 Jun 2019 13:41:12 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/7/19 8:20 AM, Brian Foster wrote:
> On Thu, Jun 06, 2019 at 10:30:09PM -0500, Eric Sandeen wrote:
>> This adds the "build options" string to a sysfs entry:
>>
>> # cat /sys/fs/xfs/features/build_opts 
>> ACLs, security attributes, realtime, scrub, no debug
>>
>> because right now we only get it in dmesg and scraping dmesg
>> is not a great option.
>>
>> This is really /build options/, not features as in "on-disk,
>> superblock features" like XFS_SB_FEAT_* - putting this under a
>> features/ dir will leave the window open open to do supported
>> superblock features ala ext4 & f2fs in the future if desired.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> No sure if it would make sense to have i.e.
>>
>> /sys/fs/xfs/features/build_options
>> /sys/fs/xfs/features/finobt
>> /sys/fs/xfs/features/rmapbt
>> ...
>>
>> all in the same features/ dir ?
>>
> 
> What's the purpose of the features dir, and why an entry per feature as
> opposed to a single 'features' file like we're adding for build_opts?

just because ext4 and f2fs did it that way, and supposedly sysfs
is one value per file.

also our entire sysfs structure is based around having dirs under xfs/
- tbh I haven't yet sorted out how to actually ad a bare file under
xfs/ ;)  Of course it's possible but existing infra in our code is friendlier
with subdirs of files.  ;)

> Would those per-feature files present any data? The patch seems
> reasonable to me in general, but I'd prefer to see the directory
> structure thing at least hashed out before we decide on this kind of
> placement (as opposed to something like /sys/fs/xfs/build_opts, if that
> is possible).

Yeah, that's why I raised the question above, stupid me ;)

> I see that ext4 has a per-file feature dir along these lines:
> 
> $ ls /sys/fs/ext4/features/
> batched_discard  encryption  lazy_itable_init  meta_bg_resize  metadata_csum_seed
> $ cat /sys/fs/ext4/features/*
> supported
> supported
> supported
> supported
> supported
> 
> I'm not sure if those files disappear when a feature is not available or
> persist and return something other than "supported?" Are those files
> used by anything in userspace?

It's based on what the running code can support, i.e. the total of its
COMPAT_FEATURES stuff.

>> Also I didn't test module unload/teardown as I'm testing on xfs root.
>>
> 
> insmod/rmmod works on a quick test on one of my VMs.

thanks, sorry for being lazy there.

-Eric

> Brian
> 
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index a14d11d78bd8..bc0e7fd63567 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -55,9 +55,10 @@
>>  static const struct super_operations xfs_super_operations;
>>  struct bio_set xfs_ioend_bioset;
>>  
>> -static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
>> +static struct kset *xfs_kset;			/* top-level xfs sysfs dir */
>> +static struct xfs_kobj xfs_features_kobj;	/* global features */
>>  #ifdef DEBUG
>> -static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>> +static struct xfs_kobj xfs_dbg_kobj;		/* global debug sysfs attrs */
>>  #endif
>>  
>>  /*
>> @@ -2134,11 +2135,16 @@ init_xfs_fs(void)
>>  	if (error)
>>  		goto out_free_stats;
>>  
>> +	xfs_features_kobj.kobject.kset = xfs_kset;
>> +	error = xfs_sysfs_init(&xfs_features_kobj, &xfs_features_ktype,
>> +				NULL, "features");
>> +	if (error)
>> +		goto out_remove_stats_kobj;
>>  #ifdef DEBUG
>>  	xfs_dbg_kobj.kobject.kset = xfs_kset;
>>  	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
>>  	if (error)
>> -		goto out_remove_stats_kobj;
>> +		goto out_remove_features_kobj;
>>  #endif
>>  
>>  	error = xfs_qm_init();
>> @@ -2155,8 +2161,10 @@ init_xfs_fs(void)
>>   out_remove_dbg_kobj:
>>  #ifdef DEBUG
>>  	xfs_sysfs_del(&xfs_dbg_kobj);
>> - out_remove_stats_kobj:
>> + out_remove_features_kobj:
>>  #endif
>> +	xfs_sysfs_del(&xfs_features_kobj);
>> + out_remove_stats_kobj:
>>  	xfs_sysfs_del(&xfsstats.xs_kobj);
>>   out_free_stats:
>>  	free_percpu(xfsstats.xs_stats);
>> @@ -2186,6 +2194,7 @@ exit_xfs_fs(void)
>>  #ifdef DEBUG
>>  	xfs_sysfs_del(&xfs_dbg_kobj);
>>  #endif
>> +	xfs_sysfs_del(&xfs_features_kobj);
>>  	xfs_sysfs_del(&xfsstats.xs_kobj);
>>  	free_percpu(xfsstats.xs_stats);
>>  	kset_unregister(xfs_kset);
>> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
>> index cabda13f3c64..98f36ad16237 100644
>> --- a/fs/xfs/xfs_sysfs.c
>> +++ b/fs/xfs/xfs_sysfs.c
>> @@ -222,6 +222,28 @@ struct kobj_type xfs_dbg_ktype = {
>>  
>>  #endif /* DEBUG */
>>  
>> +/* features */
>> +
>> +STATIC ssize_t
>> +build_opts_show(
>> +	struct kobject	*kobject,
>> +	char		*buf)
>> +{
>> +	return snprintf(buf, PAGE_SIZE, "%s\n", XFS_BUILD_OPTIONS);
>> +}
>> +XFS_SYSFS_ATTR_RO(build_opts);
>> +
>> +static struct attribute *xfs_features_attrs[] = {
>> +	ATTR_LIST(build_opts),
>> +	NULL,
>> +};
>> +
>> +struct kobj_type xfs_features_ktype = {
>> +	.release = xfs_sysfs_release,
>> +	.sysfs_ops = &xfs_sysfs_ops,
>> +	.default_attrs = xfs_features_attrs,
>> +};
>> +
>>  /* stats */
>>  
>>  static inline struct xstats *
>> diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
>> index e9f810fc6731..e475f6b7eb91 100644
>> --- a/fs/xfs/xfs_sysfs.h
>> +++ b/fs/xfs/xfs_sysfs.h
>> @@ -11,6 +11,7 @@ extern struct kobj_type xfs_mp_ktype;	/* xfs_mount */
>>  extern struct kobj_type xfs_dbg_ktype;	/* debug */
>>  extern struct kobj_type xfs_log_ktype;	/* xlog */
>>  extern struct kobj_type xfs_stats_ktype;	/* stats */
>> +extern struct kobj_type xfs_features_ktype;	/* features*/
>>  
>>  static inline struct xfs_kobj *
>>  to_kobj(struct kobject *kobject)
>>

