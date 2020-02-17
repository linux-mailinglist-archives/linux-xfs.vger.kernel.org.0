Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C6A161400
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgBQNx5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:53:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728378AbgBQNx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ARb7EKpje1CVmFvBSN7r8FxPt+NVWWpXbrFwMHvPyaw=; b=DOEdbwTVYIwAAUriIP/scgSKCB
        U0DQ2RtByXKFWudPzM8h394IBJU7L4df6LMD6xkvDEz+TR6eMWDwqY/bgaLAtzkk/abUWwQx7sn1u
        FEwYmwGl6fX/6iE+KAe7hI89rgdkGYyeaDq4w1rrOhdE9W50BeUjxMxCY5GZSo2BVZNdYjaX1iZfE
        0DtfMsL7vz+l73nJy0mcYA69E/9VJIx7LkKVjC8fzG8OEpkAnhXC/zFgBuNcPmnErqAAd3qBFJMLn
        TeBSpzwdN7Ih2Qv8T/uwuzDosYdf8Z3sKyxdxup46oUC7kcVqzy/6xifmQvwtHA3EtJy3cepBowhX
        NYVgMjQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gqS-00022D-Js; Mon, 17 Feb 2020 13:53:56 +0000
Date:   Mon, 17 Feb 2020 05:53:56 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 6/7] xfs_repair: check plausibility of root dir pointer
 before trashing it
Message-ID: <20200217135356.GJ18371@infradead.org>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086363533.2079685.15692340020655871081.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086363533.2079685.15692340020655871081.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:47:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If sb_rootino doesn't point to where we think mkfs should have allocated
> the root directory, check to see if the alleged root directory actually
> looks like a root directory.  If so, we'll let it live because someone
> could have changed sunit since formatting time, and that changes the
> root directory inode estimate.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
