Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B721A3057
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Apr 2020 09:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgDIHko (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Apr 2020 03:40:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51570 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgDIHko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 03:40:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=eEbetV4QyqvKudPTqgmg82HiD5
        sWIL6+PC2n7bRUFWNNj/f35EQ3PmWJEm2UXnZaSXwyKtvjtrn2F/qFe8vPwmSVpmcAJqx3NE/QcXD
        U2yrAgGJCZ8MtwlfkpvgJVi9K1MQiEbUD6ppOFlE1p0NDpgi3l58OMZAXRNRJXwCcj2z2D5/aDts1
        9Klofeuwe4bn36BTh6DK1roTqHQg9Z0GyvbpeldV5lbfjCvA+3a02kt50z9+Vi2elqCjTfd1pCVcb
        qLB4YiCVneCnUPSZuimGjqfTDNOyXNk6QW5WvxbjFbmiCzhVPwS6Cg8gNbC4UODJ1w8XS9hDWpCOk
        xkrBb4rg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMRno-0008B2-Va; Thu, 09 Apr 2020 07:40:44 +0000
Date:   Thu, 9 Apr 2020 00:40:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: acquire superblock freeze protection on eofblocks
 scans
Message-ID: <20200409074044.GC21033@infradead.org>
References: <20200408122119.33869-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408122119.33869-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
