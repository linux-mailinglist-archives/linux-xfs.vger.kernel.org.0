Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C258F28EE70
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgJOI0c (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgJOI0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:26:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6433BC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=jBu/bNpEBoacPsfQJElI7nMQfQ
        UoEt+qF69DJ+qnSJAKQUVEd49pKX9WKz5EqZJDIVA0XIw7p8Hm5V5NKUYyG/Q+F7FYdpjz4+AVhVz
        KleipxEmeD7kY0Q9g9azCJd6fTe4e9kH1CEbJ3srT8s0ub2gcAJjMR7ZO1WtZ+XKjqYBmV7EKyamG
        qfRZ+hZDbjubIsRIVMSz228AkbuGP8z6WaaRJ0cCEpuFWBWpDYI0XBe7ppdYm533oBCTrWa8dQiLa
        BtwhxHTsdSfOh/JDG93J5LlkNrUFsu9UBw/zxEU75xKAXAr7lSBCr89puE1rgUW5o9YADWOHpf9qD
        bOW4YbEA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyai-0001De-AG; Thu, 15 Oct 2020 08:26:28 +0000
Date:   Thu, 15 Oct 2020 09:26:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libfrog: fix a potential null pointer dereference
Message-ID: <20201015082628.GB4450@infradead.org>
References: <20201008035732.GA6535@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008035732.GA6535@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
