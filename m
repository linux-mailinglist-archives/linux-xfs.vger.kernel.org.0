Return-Path: <linux-xfs+bounces-31205-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IOp6ETc6nGlCBgQAu9opvQ
	(envelope-from <linux-xfs+bounces-31205-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Feb 2026 12:29:59 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5E817587E
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Feb 2026 12:29:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 338563031F34
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Feb 2026 11:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B935834E75E;
	Mon, 23 Feb 2026 11:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KPYoNYtw"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766D134DCCC
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771846152; cv=none; b=boQuXN1tyoTV/NBFs1ckTSPKPDAtgYG11BnHQsRI3Q/7742URsDebbkUtU/h2w6V9yCzn5R33+oCoMhgfnEkhYqgkGsoby/qChOPd2SXe8Kb1NScZD2GGAZ7sQZ8CjCqGCyhtVTqq6aqeqzudTylEWrfuT6MP8YRMp4WhU32Twk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771846152; c=relaxed/simple;
	bh=minexp1hrWimMHLEY9FDZS0PwNii3WufiEwwoHxZl0M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=lxihyGecHwbqsP+RmuxIMzyRoFY37EjGaWWvu7V4LLFXyHObN0wM+paMCKY3K98T2Hq1W6A3qxclD08nFoHNoClJ1zz77io/UavU6Pcrf8vHl+jTuWhXUkJoEeQ7sSucG5Bd/qLPnRNqYMjAyAeRCX6RchDFKZwcM9rI6o5uyyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KPYoNYtw; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2aad1dc8856so29684295ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 03:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771846151; x=1772450951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gUPUqcruGdRF+QmccK0f6cTHJ0qRsoMn0qsfNlhX9BI=;
        b=KPYoNYtwZdI8YNy5lnMHe38FcFLLILW62gkr9aCW0YS3AiL9hdPvP3Y+ZYaUKL2Gzn
         6TfamjpqYQbHdDnwQwd8BghVcXqj/X5+WZulnxQUgGUyjlmpK9HcaaTTBSOGq2ybwIBn
         f2C41uczuw/Dr9BURTReDidNLrfntRP3gzSq4obrAuCrfbBKojfoKXOpS2CmS+ZQlgrQ
         mDT9qP2tMHJBjiFH+qT/Y3A0Lgb/aropcHMkD8W9JxznCnrpSmxd+Q3Ti55Y1GIFigyK
         5eqg459pca3n6H/jT8VLZlYjVhWOQLmE6C3Cw/1N/jjbPDrMzdFP6S9Ef03Iz6Oio0zr
         9qaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771846151; x=1772450951;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gUPUqcruGdRF+QmccK0f6cTHJ0qRsoMn0qsfNlhX9BI=;
        b=rgHlfpB5ebb5MPvxW0/NBcobN5PM32OpBaToK/Dc0qyJwFGGpBPWX+W4hxS3uRK00v
         bUFmiq7qrtrQFkgQ4gyYzOafbnZhLm8+gIHPAYps3ips8VnQqdoAGcAJRanN9koiCCcs
         EGCbsTYABX08IOO/TYnYNfoR1DSU1IhqlNaEVPwIjyhC+YNZoV1NBUz448AMneKNHaNR
         2ignoNf+ZEqpOg5tLUShtqvqOeKf+v++aQI+DXsa8fWtnndQycoP6AQQauRy8qa2xB9y
         uDhHDVelzQKqJyaAUJUYnv9tDa50KTda2beG2gDGA/bVgcQozHYoE0aCqV2sqGBg8xvO
         sdmw==
X-Gm-Message-State: AOJu0YzWC2GRiM31Ek6Fhg7r73EWNxzm+9ZQREHQ6RlC3IRhAZi0cznV
	P1bSJjqQpIpafAgmxV5/N48+EyLtTJjkksHSeIWVsJcshF9i8P5FfusFYabLwA==
X-Gm-Gg: ATEYQzyYA+2C3qvTswyQ/WszAz0mJAZYjkwDaoYJvk1JJw1Wa2EN9hK3qmh8uGslp/m
	ziD2lwwF5QF1JCEHm96GAdv0RI67IovE2AyX928nHyyqxfG/+A9s6r9rStQGTRcaRiI7f0dz0tW
	RfmAj7w61/y6aDoXwnDZvxvphEQ8rbq0Bxci/wA9ITNbtobGUdlGZW1deNF9f6Y1Fgof9aoJn4i
	rO1QfwSEEsCNmZkY50vL5TE95COLX5kdleh4h/xCKfijCgvQP0XG7LaxeVmW697+Pt0QXcRvByM
	QdVslaJ1uC8FAGFSkZ+DlDaEpEBSbrdg2TmebcLA8yh3b/IOR+3bphVF7Z2kRPPU/lhcAIVOFeM
	l/i8iLmhWkENcezJxU4nWd7dL2kQUWhyHmsOpyJK9s2VMDjY9JVtWYoREVhoAJu+4bxB7qGCmIh
	yETNT9Z0FOzWRRhu0OYMeEmG4kZmZV2RwivoElRYUd97ioCwzlFcTlhNeTPI1xz7kq9ZteYejvI
	69l
X-Received: by 2002:a17:903:2283:b0:295:560a:e499 with SMTP id d9443c01a7336-2ad74419fb9mr68131985ad.5.1771846150791;
        Mon, 23 Feb 2026 03:29:10 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.233.114])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad75321543sm73424095ad.72.2026.02.23.03.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 03:29:10 -0800 (PST)
Message-ID: <de1ac9aa2e6f9f1701f9d9efd6ef443466fd5c47.camel@gmail.com>
Subject: Re: [RFC v1 0/4] xfs: Add support to shrink multiple empty rtgroups
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
 ritesh.list@gmail.com,  ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Date: Mon, 23 Feb 2026 16:59:04 +0530
In-Reply-To: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
	 <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31205-lists,linux-xfs=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,linux.ibm.com,linux.alibaba.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nirjharroylists@gmail.com,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DD5E817587E
X-Rspamd-Action: no action

On Thu, 2026-02-19 at 11:33 +0530, Nirjhar Roy (IBM) wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> This work is based on a previous RFC[1] by Gao Xiang and various ideas
> proposed by Dave Chinner in the RFC[1].
> 
> The patch begins with the re-introduction of some of the data
> structures that were removed, some code refactoring and
> finally the patch that implements the multi rtgroup shrink design.
> We can remove only those rtgroups which are empty.
> For non-empty rtgroups the rtextents can migrated to other rtgroups
> (assuming the required amount of space is available).
> I am working on the patch series [2](by Darrick and
> Dave) for completion of the data block migration from the end of the
> filesystem for emptying an realtime group. That will be a future work
> after this.
> The final patch has all the details including the definition of the
> terminologies and the overall design.
> 
> The design is quite similar to the design of data AG removal implemented
> in the patch series[3] that I have posted earlier.
> The reason for keeping [3] on hold and posting this patch series is
> that (based on the discussion in [5], [6]), realtime devices won't have any
> metadata/inodes and migrating data from the end of realtime devices will
> be simpler. On the other hand there are challenges in moving metadata
> from regular AGs especially inodes.
> 
> Please note that I have added RBs from Darrick in patch 1 which was
> given in [4].
> 
> Instructions to test this patch:
> $ Apply the patch for xfsprogs sent with this series and install it.
> $ mkfs.xfs -f -m metadir=1  -r rtdev=/dev/loop2,extsize=4096,rgcount=4,size=1G \
> 	-d size=1G /dev/loop1
> $ mount -o rtdev=/dev/loop2 /dev/loop1 /mnt/scratch
> $ # shrink by 1.5 rtgroups
> $ xfs_growfs -R $(( 65536 * 2 + 32768 ))  /mnt1/scratch
> 
> I have also sent the tests.
> 
> [1] https://lore.kernel.org/all/20210414195240.1802221-1-hsiangkao@redhat.com/
> [2] https://lore.kernel.org/linux-xfs/173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs/
> [3] https://lore.kernel.org/linux-xfs/cover.1760640936.git.nirjhar.roy.lists@gmail.com/
> [4] https://lore.kernel.org/all/20250729202632.GF2672049@frogsfrogsfrogs/
> [5] https://lore.kernel.org/linux-xfs/aPnMk_2YNHLJU5wm@infradead.org/
> [6] https://lore.kernel.org/linux-xfs/aPiFBxhc34RNgu5h@infradead.org/

Hi Darrick,

Please find the github branches for the changes in the patchsets:
kernel changes - https://github.com/Nirjhar-Roy-0211/linux/commits/xfs-shrink-rt-v1/
userpace changes - https://github.com/Nirjhar-Roy-0211/xfsprogs-dev/commits/xfs-shrink-rt-v1/
fstests - https://github.com/Nirjhar-Roy-0211/xfstests-dev/commits/xfs-shrink-rt-v1/

--NR

> 
> Nirjhar Roy (IBM) (4):
>   xfs: Re-introduce xg_active_wq field in struct xfs_group
>   xfs: Introduce xfs_rtginodes_ensure_all()
>   xfs: Add a new state for shrinking
>   xfs: Add support to shrink multiple empty realtime groups
> 
>  fs/xfs/libxfs/xfs_group.c     |  18 +-
>  fs/xfs/libxfs/xfs_group.h     |   4 +
>  fs/xfs/libxfs/xfs_rtgroup.c   | 105 ++++-
>  fs/xfs/libxfs/xfs_rtgroup.h   |  31 ++
>  fs/xfs/xfs_buf_item_recover.c |  25 +-
>  fs/xfs/xfs_extent_busy.c      |  30 ++
>  fs/xfs/xfs_extent_busy.h      |   2 +
>  fs/xfs/xfs_inode.c            |   8 +-
>  fs/xfs/xfs_mount.h            |   3 +
>  fs/xfs/xfs_rtalloc.c          | 824 +++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_trans.c            |   1 -
>  11 files changed, 1023 insertions(+), 28 deletions(-)
> 
> --
> 2.43.5
> 


