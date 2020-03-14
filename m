Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13FA8185AEE
	for <lists+linux-xfs@lfdr.de>; Sun, 15 Mar 2020 08:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgCOHPh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 15 Mar 2020 03:15:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49192 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgCOHPg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Mar 2020 03:15:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=A8fCDJahJwQa6zWia1Y+yAtZoR+hh9mfxUFKEamDfiI=; b=CYedIf1ELY2qAxAOc1LQvcAd3k
        Ja6pniQsSVbmCDrkm4nWgF5soTdE9WmAUIVrBNzOwJix0DW2uhZxWcWiZF2BqW7QEK/dLM0w/Dclq
        5k8o/HNe22aSROCSQnz74hIQzQ5nYaemtnskvkFfTwj9xTaweEds4R70X1k6lDDQOiTSbgsGnX2Qh
        SXw7RBpIGonsmATRjyutkjg+STy4SyjU7h12W2H1dZsezsnwVaZZtoY0hVqs14DZj45uUJGhBl14/
        LLuTAeygy+lUsWLfHw0ZAKo/arypllqAjxG6ilrEwCfsOGpx+Ub0Tj/Fbtdlp2Ue5XdlENZ3a7x/d
        zDL90tbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDBMJ-0008UZ-Sh; Sat, 14 Mar 2020 18:18:03 +0000
Date:   Sat, 14 Mar 2020 11:18:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: xfs_dabuf_map should return ENOMEM when map
 allocation fails
Message-ID: <20200314181803.GA32575@infradead.org>
References: <20200314172913.GA6756@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314172913.GA6756@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 14, 2020 at 10:29:13AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the xfs_buf_map array allocation in xfs_dabuf_map fails for whatever
> reason, we bail out with error code zero.  This will confuse callers, so
> make sure that we return ENOMEM.  Allocation failure should never happen
> with the small size of the array, but code defensively anyway.
> 
> Fixes: 45feef8f50b94d ("xfs: refactor xfs_dabuf_map")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
