Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8DF16ECF5
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 18:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbgBYRps (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 12:45:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57320 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730222AbgBYRps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:45:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0ZyFeHEll6CyTBmyeevwL4JEFNt7647v6F72yTC1s58=; b=MKrXvFSbdWCE3y3e/hXTXWUT+f
        sd8x+iYLf2PEWlxoda48Yd5oyj7WljYvMI6QEqYCFlr7+PlWsflcFuIreIXyYAIbD8io6eL2T6UtY
        wtdJ6JC2LtFvMhj65/ww7YMLulsVjKdms3l3nbQErzBQ1CWlY5A8ouvEKtyfs3At31pQ8K5RqfZna
        wLupvRIwnXl348ZrjyuiQSCbHfl9X+uuZ7EbmO1qNXleUfW+XpulBad47b2EDD/SmyYxYFt+kDn8d
        o4AmBv0grzVRawQRtD/SLoy125gge/W2Yrt3uITjkfV+r5/CmAAGBqaiDpENzRsc9noe0/MXHkRXe
        VtOljDRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eHD-0007T2-6k; Tue, 25 Feb 2020 17:45:47 +0000
Date:   Tue, 25 Feb 2020 09:45:47 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/25] xfs_copy: use uncached buffer reads to get the
 superblock
Message-ID: <20200225174547.GM20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258956405.451378.5036099292043192938.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258956405.451378.5036099292043192938.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:12:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Upon startup, xfs_copy needs to read the filesystem superblock to mount
> the filesystem.  We cannot know the filesystem sector size until we read
> the superblock, but we also do not want to introduce aliasing in the
> buffer cache.  Convert this code to the new uncached buffer read API so
> that we can stop open-coding it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
