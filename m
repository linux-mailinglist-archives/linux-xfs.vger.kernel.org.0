Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFB9179418
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2020 16:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgCDPxd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 10:53:33 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51586 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgCDPxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 10:53:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZpYlTtSTiRmWI1DjIX+At9Zxo4hWOewSTxhZjEEfvto=; b=Jn/jh0eGABfbhrhajoUK3mwijm
        Ova1tKx+Ci2wETHb8hAEL5MqrEVC4Qc67jL0csNCIU1DMrfMaoEhTo0X05gm/FumZpeR/wnAli2VU
        j84I8CRpSjhLVi2n2zBqMnyRooxME+8hrgbf8RqCq0i0xbCbPxs4NkHZrwbLpyYfwnc3ZnFKBCuUe
        VT146BAPvy+wadU1drd2UJ4rrBsvg0z1zeX9xnNkxelZs5a/aYvzxbF+7eLW/wy3dAziTFTlRvCsf
        YOEQZVMGnRVYBlEAS84NDol5QaHm90fs5hg0CSvdiLmqqRNPAqcUnz944VPTJGJ9Hx5pn2GeOuO7/
        seOCJf5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9WKy-0001xg-TG; Wed, 04 Mar 2020 15:53:32 +0000
Date:   Wed, 4 Mar 2020 07:53:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: merge unmount record write iclog cleanup.
Message-ID: <20200304155332.GG17565@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:59PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The unmount iclog handling is duplicated in both
> xfs_log_unmount_write() and xfs_log_write_unmount_record(). We only
> need one copy of it in xfs_log_unmount_write() because that is the
> only function that calls xfs_log_write_unmount_record().

The copy in xfs_log_unmount_write actually is dead code.  It only
is called in the XLOG_FORCED_SHUTDOWN case, in which case all iclogs
are marked as STATE_IOERROR, and thus xlog_state_release_iclog is
a no-op.  I really need to send the series out to clean this up
ASAP..
