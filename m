Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4596726D561
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 09:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgIQH4Y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 03:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgIQHuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:50:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40F6C061756;
        Thu, 17 Sep 2020 00:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UfiU318F9O1q0e7vo3h9PMlx+KUukSblMUMpcHv4dcY=; b=bd0gMtBKmvZjpFG/5lvn+U+Zqq
        WbFwVPPbE+hRyLuEOV1ipmeGI9Jbue+6WACrhmFGFC0ZKUiw13QsWsOZHhjc3+3uB0q0FRIgRJroy
        BvJ80e+fgepkjdazHm1LyXTDcj+OiDgnRkErQYZdNSxDKaHsL0VYtNqDADH0V4r+f6+Uy4NLhgWNs
        l5GDukN2g7nNvJSFZPpNaF+DU7niMUrP44rDSnh+60ZQAsl/Vb+ti5BVG1WGmb8S+EjFBEpRSls44
        keSmExpWw6H4BrRbbOiwECDmsINGnZEWY7bPRdMVD0Zg1LpHeYZ0B/ZotEo1oi/v/5TAPmrbjz/9l
        7oDQimog==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIogq-0006xc-GS; Thu, 17 Sep 2020 07:50:48 +0000
Date:   Thu, 17 Sep 2020 08:50:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 01/24] xfs/331: don't run this test if fallocate isn't
 supported
Message-ID: <20200917075048.GA26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013418077.2923511.4423324916550074038.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013418077.2923511.4423324916550074038.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:43:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This test requires fallocate, so make sure that actually works before
> running it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
