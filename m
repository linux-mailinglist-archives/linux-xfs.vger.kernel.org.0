Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A3D3072E4
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jan 2021 10:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhA1Ji6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jan 2021 04:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbhA1Jaq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:30:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837A2C061574
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Hqpe4aD83IWZVFFH1IfQMkvddX1n66tF3OUK/vAboa0=; b=rVZ/SP1bpexcoLyJLxqD36sfmG
        nVm/ZrALPQQsmtrvPszzeENnofCYa6li6GqKguJU/ybXm8maUxrbn5Z0uFFMNGUmVE3OZVKIY8m23
        hdcnXZrpgfxbOlqocJAcHsOGQtibveIRKRU76tkSXFzsc0aQC6UCYcRhKnU/e/COwP/r9t0psB05/
        /mZ6D2gS3AFm5zfhGrzIP35fiUKg4NSmoMavRFYRoMjpFlF/LkXm08V2e2NCjbpnnwujq6OM8P4Vw
        epTv7wnyvMAfdkoU82FiBjoZo+53ibatflYULhyvRchkzkBvkRub9S/qtTKdLKhDALTFF2hrDuJcK
        J0bF9ycQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l53co-008GPO-Ji; Thu, 28 Jan 2021 09:30:03 +0000
Date:   Thu, 28 Jan 2021 09:30:02 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 11/11] xfs: don't bounce the iolock between
 free_{eof,cow}blocks
Message-ID: <20210128093002.GE1967319@infradead.org>
References: <161181381898.1525433.10723801103841220046.stgit@magnolia>
 <161181388185.1525433.9983196119474305213.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181388185.1525433.9983196119474305213.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:04:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since xfs_inode_free_eofblocks and xfs_inode_free_cowblocks are now
> internal static functions, we can save ourselves a cycling of the iolock
> by passing the lock state out to xfs_blockgc_scan_inode and letting it
> do all the unlocking.

Looks good, although normally we use lock_flags and not unlockflags
for this kind of variable, and maybe we should stick to that here.

Reviewed-by: Christoph Hellwig <hch@lst.de>
