Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4D6787BC6
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Aug 2023 01:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbjHXXDT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 24 Aug 2023 19:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244013AbjHXXDH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:03:07 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF0A1BFE
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:03:00 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c0bae4da38so3088385ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692918179; x=1693522979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xIeXmYOGg0Mhq47yjfx3bWVUg+YpniF+ytvojUSGwVY=;
        b=tByMDkanuIhtDd2n7P2zSHHFBGJqCpDTTxA41BtYn1kL6ZhvqIBAs4Prl4nfY3tWJR
         Kwcfcl30+wRiKPVoDMGArkm8xQUwAzY5w4cN/7DuGQ9r9RlA9LeyjSim6O1M+kTcz6lZ
         1APgX51TXqVMf0xolsJuiBhRG6wGtsskLT2Y2HTwJVh3VNL5l1Z9ca1TLSlzWwD/PQmH
         YlUkbY2B3+7vS+/fT1EtN4nLC+JFXL+jFMRugipgSrXX7peNQeWHctYlpl+jnae8ynf2
         K9tpn1at9vgxa5cP2CaHo0j7diiDGTdB0hljPOO2Vq9KXas4ciOMLG/YfLJSsY3jHkOv
         vOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692918179; x=1693522979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xIeXmYOGg0Mhq47yjfx3bWVUg+YpniF+ytvojUSGwVY=;
        b=VBiJJDUItSuQSurW2rwBNAfgUiCnUbDaQg5ndMLTjpMqiERM73+XvqCC7tRkQPBejB
         EbTfGDw4AgsMi47EXJh1II4+VZA5mJmFKc/IlE26nxhL9q7pv4HGmpAMhtpGrj65bzn3
         oGu8S2//21eWnW13+AQnSelBN6oIvt95jNq5X4IQKN+6gdXAGEhaNCeVsgICp4atulyG
         Tgi3YSOpXFgeoKuk80cZ0JQBmKp6a39Et6IknjONhJRqXIhxpVTqMxtELRlGrTk3NxGp
         eag6wHtgPExkQDjKkDfbfDfSZ6SotwQVC64HQJcfBLh77+SwGCFtBJtQylqk3gJ7LYyi
         3HcQ==
X-Gm-Message-State: AOJu0YwZO4sBsTil9c+/Og8UnlulT16hK3QbDxRa+TIdiM6bewvaNllM
        fk299t7i5EbzJ/oQ/rgjA2N3L7qn5EleNOjPTec=
X-Google-Smtp-Source: AGHT+IF2go0df+GJgAhiRgp9LQG8t5k5ztsh550mui4oAXnm7qe7blgv1JH2hSyj+3wOOthtvYRQjg==
X-Received: by 2002:a17:902:d4c1:b0:1bc:5e36:9ab4 with SMTP id o1-20020a170902d4c100b001bc5e369ab4mr26813582plg.21.1692918179525;
        Thu, 24 Aug 2023 16:02:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id iy13-20020a170903130d00b001b05e96d859sm194340plb.135.2023.08.24.16.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 16:02:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZJLs-0065MX-18;
        Fri, 25 Aug 2023 09:02:56 +1000
Date:   Fri, 25 Aug 2023 09:02:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     cheng.lin130@zte.com.cn
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: Re: [PATCH] xfs: introduce protection for drop nlink
Message-ID: <ZOfhoLql0TYiD5JW@dread.disaster.area>
References: <202308241543526473806@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202308241543526473806@zte.com.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 03:43:52PM +0800, cheng.lin130@zte.com.cn wrote:
> From: Cheng Lin <cheng.lin130@zte.com.cn>
> An dir nlinks overflow which down form 0 to 0xffffffff, cause the
> directory to become unusable until the next xfs_repair run.

Hmmm.  How does this ever happen?

IMO, if it does happen, we need to fix whatever bug that causes it
to happen, not issue a warning and do nothing about the fact we
just hit a corrupt inode state...

> Introduce protection for drop nlink to reduce the impact of this.
> And produce a warning for directory nlink error during remove.
> 
> Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
> ---
>  fs/xfs/xfs_inode.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9e62cc5..536dbe4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -919,6 +919,15 @@ STATIC int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
>  	xfs_trans_t *tp,
>  	xfs_inode_t *ip)
>  {
> +	xfs_mount_t     *mp;
> +
> +	if (VFS_I(ip)->i_nlink == 0) {
> +		mp = ip->i_mount;
> +		xfs_warn(mp, "%s: Deleting inode %llu with no links.",
> +			 __func__, ip->i_ino);
> +		return 0;
> +	}

This is obviously incorrect - whiteout inodes (RENAME_WHITEOUT) have an
i_nlink of zero when they are removed from the unlinked list. As do
O_TMPFILE inodes - when they are linked into the filesystem, we
explicitly check for i_nlink being zero before calling
xfs_iunlink_remove().

> +
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
> 
>  	drop_nlink(VFS_I(ip));

Wait a second - this code doesn't match an upstream kernel. What
kernel did you make this patch against?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
