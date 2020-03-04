Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2AE179411
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2020 16:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgCDPvD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 10:51:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51514 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgCDPvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 10:51:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HvFlFcv33jMWQo/2Y98AGEnZfOu7RKnc97e3cQieL28=; b=lxti0iL2+h6hVPxaXLW/scifwp
        eG27Rl4I+8HvtNpTvSNLi92EcWFy1NCQEzRB9e8OvYv6xsbEbv9YCZoPBJooxSFB1uDGEAoSe3yWu
        3z9DPSC6GQiKHnxvJe+xFMHW3LmV4cfRUAavPyZ8u1BSH98s1SD5eIB/566VFsWvuR6l98Xmqa3Gr
        6CX5IsCUn5/641g7o0znANBnNjVcojTmSfQqh09AkLWZ82vMOACX6+37su6Lg1gIefYYEVR7j7thV
        l9ks78YUn41NakIoQoUQel1lQ/yNhBBjqHcgeZ/csLGagk7lJX7zChE2mB57IXoxDjXjbqCSxA+G9
        JATCTJHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9WIZ-0001pm-0m; Wed, 04 Mar 2020 15:51:03 +0000
Date:   Wed, 4 Mar 2020 07:51:02 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: factor out unmount record writing
Message-ID: <20200304155102.GD17565@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:55PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Separate out the unmount record writing from the rest of the
> ticket and log state futzing necessary to make it work. This is
> a no-op, just makes the code cleaner and places the unmount record
> formatting and writing alongside the commit record formatting and
> writing code.
> 
> We can also get rid of the ticket flag clearing before the
> xlog_write() call because it no longer cares about the state of
> XLOG_TIC_INITED.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
