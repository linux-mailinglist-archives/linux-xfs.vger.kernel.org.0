Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFB3D4064
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2019 15:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfJKNGV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 11 Oct 2019 09:06:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33288 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbfJKNGV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 09:06:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0KOxJqjgY7dUI6kvFq+KguD5cvSrEqK7JOmumHWOcEQ=; b=VEWMtwN4bymxkS7HkfwQmsmjy
        IjAi13JDizXtG6xzigzl7f2KzggGbjsUls84LBDJRjYabdjaNvtO8qsQCNV5ZmZPljopdVTPUulTT
        sqJsGWRYpYBBEL01pE586MYMe8XzuwzOpxChno2mOgmnhuQJNJRUxrAoema+WU3oEC4kJugUK633Y
        GSZS+ZM5ZiEy0A37g4KgSBMNdgjNr3PzCLcwpYwsnEx/9A210GQZEExqDe1r3ckQ76RDLQikrM4lh
        +MAE6OQspWTSfeVEHwFjc1lJFtYeavn4WBZQ6mVdALHpD89Iid0nPmuQF6qObplYoXhTwm0GFE5Ay
        g0J690Lgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIucZ-0000NO-9X; Fri, 11 Oct 2019 13:06:15 +0000
Date:   Fri, 11 Oct 2019 06:06:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     yu kuai <yukuai3@huawei.com>
Cc:     darrick.wong@oracle.com, bfoster@redhat.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengbin13@huawei.com, yi.zhang@huawei.com, zhangxiaoxu5@huawei.com
Subject: Re: [PATCH] xfs: fix wrong struct type in ioctl definition whih cmd
 XFS_IOC_GETBMAPAX
Message-ID: <20191011130615.GA27614@infradead.org>
References: <1570792486-84374-1-git-send-email-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570792486-84374-1-git-send-email-yukuai3@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 11, 2019 at 07:14:46PM +0800, yu kuai wrote:
> ioctl expect 'getbmapx' as the 'arg' when the cmd is XFS_IOC_GETBMAPX.
> But the definition in 'xfs_fs.h' is 'getbmap'

Strictly speaking that is true.  But changing this defintion will break
existing userspace given that _IOWR encodes the structure size.  If you
had reported this 16 years earlier we could have fixed it.
