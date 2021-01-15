Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2C82F77D1
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Jan 2021 12:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbhAOLlE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 15 Jan 2021 06:41:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34372 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbhAOLlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jan 2021 06:41:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610710777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cs0P/dtG4sLropojkxzJlys8PJnnneu/nHPVHN2xyis=;
        b=a6qsP8ZLyt/lKa0gyHONb04ELXk/11uT5wGUR+yLtqyxg3cMdlD1kLkqt3RrBf61WvW3ur
        2L5bmYyg+k0jbGzyfK6I/mGpsX2TrA0SuicRXwLdegYDp7+6/FyjNXapoIco7UfWAWWRhV
        Q3vvB2Ix68W63aOmywo5/F5QuCh4BtY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-hU2HZBp1OPawbAFjESfFOw-1; Fri, 15 Jan 2021 06:39:35 -0500
X-MC-Unique: hU2HZBp1OPawbAFjESfFOw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E2391034B22;
        Fri, 15 Jan 2021 11:39:34 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97B0210023BE;
        Fri, 15 Jan 2021 11:39:33 +0000 (UTC)
Date:   Fri, 15 Jan 2021 06:39:31 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Yumei Huang <yuhuang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Subject: Re: [PATCH] xfs: Fix assert failure in xfs_setattr_size()
Message-ID: <20210115113931.GA1405324@bfoster>
References: <316142100.64829455.1610706461022.JavaMail.zimbra@redhat.com>
 <1492355130.64829487.1610706535069.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1492355130.64829487.1610706535069.JavaMail.zimbra@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 15, 2021 at 05:28:55AM -0500, Yumei Huang wrote:
> An assert failure is triggered by syzkaller test due to
> ATTR_KILL_PRIV is not cleared before xfs_setattr_size.
> As ATTR_KILL_PRIV is not checked/used by xfs_setattr_size,
> just remove it from the assert.
> 
> Signed-off-by: Yumei Huang <yuhuang@redhat.com>
> ---

LGTM. Thanks for the patch.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 67c8dc9..f1e21b6 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -846,7 +846,7 @@
>          ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
>          ASSERT(S_ISREG(inode->i_mode));
>          ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> -                ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
> +                ATTR_MTIME_SET|ATTR_TIMES_SET)) == 0);
>  
>          oldsize = inode->i_size;
>          newsize = iattr->ia_size;
> -- 
> 1.8.3.1
> 

