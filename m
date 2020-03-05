Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62DDB17AAE9
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2020 17:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgCEQv2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Mar 2020 11:51:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60554 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgCEQv2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 11:51:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f4MZCc2gVevTcMwzJPcRlqG9WgmME0qDFuzYVjecOtE=; b=HIru97OTAC/cyn0x8vXVpoHOyc
        ugKMudhMlcGTfzyRLSdT1yV5Hg5IlBWu/T89Ar1K0BUp0oSGUMUaWdNWK7Eufgv650VMUboUAbWdo
        NFfJcrT+U+ZX7iEblJN+7XnvTAYziopkeTAJMxLnL3P0D6TFB6p6qqR6fCY9NBslytoebu3H3YaXk
        g1VKiotiL93Grl03R9mBVTp2vQavxiEFHpI0xS7e46P0HxdNumwSqYcrPcMntQwtraM0XmVDiOIFK
        /74DIfb1g5E8fO56Xxf0EBYa1EG+Uq8zNiDgWnydYLwyTWbmwe2IKg2Rpzc+J4nF58WAEPXFFxWEp
        1xQx4EJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9tia-0003fV-G1; Thu, 05 Mar 2020 16:51:28 +0000
Date:   Thu, 5 Mar 2020 08:51:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: check owner of dir3 blocks
Message-ID: <20200305165128.GE7630@infradead.org>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294094178.1729975.1691061577157111397.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158294094178.1729975.1691061577157111397.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 05:49:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the owner field of dir3 block headers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
> +		(*bpp)->b_flags &= ~XBF_DONE;
> +		xfs_trans_brelse(tp, *bpp);
> +		*bpp = NULL;
> +		return -EFSCORRUPTED;

Although I wonder if we should factor this repeated sniplet into a
helper..
