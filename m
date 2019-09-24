Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED1EBC502
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2019 11:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfIXJjf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Sep 2019 05:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60726 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfIXJjf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 05:39:35 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7733315C030;
        Tue, 24 Sep 2019 09:39:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 57CF55C1B2;
        Tue, 24 Sep 2019 09:39:34 +0000 (UTC)
Date:   Tue, 24 Sep 2019 05:39:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: avoid unused to_mp() function warning
Message-ID: <20190924093932.GB13820@bfoster>
References: <20190924085350.GA75425@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924085350.GA75425@LGEARND20B15>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 24 Sep 2019 09:39:34 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 24, 2019 at 05:53:50PM +0900, Austin Kim wrote:
> to_mp() was first introduced with the following commit:
> 'commit 801cc4e17a34c ("xfs: debug mode forced buffered write failure")'
> 
> But the user of to_mp() was removed by below commit:
> 'commit f8c47250ba46e ("xfs: convert drop_writes to use the errortag
> mechanism")'
> 
> So kernel build with clang throws below warning message:
> 
>    fs/xfs/xfs_sysfs.c:72:1: warning: unused function 'to_mp' [-Wunused-function]
>    to_mp(struct kobject *kobject)
> 
> Hence to_mp() might be removed safely to get rid of warning message.
> 
> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_sysfs.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index ddd0bf7..f1bc88f 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -63,19 +63,6 @@ static const struct sysfs_ops xfs_sysfs_ops = {
>  	.store = xfs_sysfs_object_store,
>  };
>  
> -/*
> - * xfs_mount kobject. The mp kobject also serves as the per-mount parent object
> - * that is identified by the fsname under sysfs.
> - */
> -
> -static inline struct xfs_mount *
> -to_mp(struct kobject *kobject)
> -{
> -	struct xfs_kobj *kobj = to_kobj(kobject);
> -
> -	return container_of(kobj, struct xfs_mount, m_kobj);
> -}
> -
>  static struct attribute *xfs_mp_attrs[] = {
>  	NULL,
>  };
> -- 
> 2.6.2
> 
