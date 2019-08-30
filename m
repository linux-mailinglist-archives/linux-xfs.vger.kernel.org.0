Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D75EA2EF9
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 07:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfH3FfK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 01:35:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50794 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727216AbfH3FfK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:35:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XtH2RBS5Hz7QEnyALjAXZ8k6qzm29rTsDJ2x4qIimA8=; b=c43sVGoYR5JS0v28oqAAhHR8X
        Ga1YsEY23KVQkvqg/oXt2UasPwssc48gxufVCIKzeymmxGPb0f1jZKgcSRgg+lfJ9y8GII/ar1hEj
        41y7Gab7fEpooWD1GPd8cWfOagN0v00JtKmIYNYLbk8zyT2hzx8cHnVZTQVuEWeC5S2637WtoPIKm
        EArl57PRJYK+RU7kcSi4Ixa5VtFGcfynZkM8FYxgS+phPXbmC22NgIBsXuWNXXEIzrMPwR3M7S9bf
        fos4VYLtZ3qIUeY5srISusAA6p9rIEMyEP6hhTL8WZ1bv/z26rhxiRFldcLbDcG7fm8d30nPA492p
        FGaM+YozQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3ZYz-0007EK-Bp; Fri, 30 Aug 2019 05:35:09 +0000
Date:   Thu, 29 Aug 2019 22:35:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: move remote attr retrieval into
 xfs_attr3_leaf_getvalue
Message-ID: <20190830053509.GF6077@infradead.org>
References: <20190829113505.27223-1-david@fromorbit.com>
 <20190829113505.27223-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829113505.27223-4-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:35:03PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because we repeat exactly the same code to get the remote attribute
> value after both calls to xfs_attr3_leaf_getvalue() if it's a remote
> attr. Just do it in xfs_attr3_leaf_getvalue() so the callers don't
> have to care about it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
