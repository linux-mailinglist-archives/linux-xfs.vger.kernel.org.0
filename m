Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFA6F7A29
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Nov 2019 18:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKKRrM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Nov 2019 12:47:12 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:32774 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfKKRrM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 12:47:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=TyiZeSiqt758nMKP597ymCIDs
        ybUGH7Rp8J3LwcTKQHeRp3hSBbY1zr+rD0HdwYkrHGCkZ3xqKicyW5hDEWkmcWGwmZq7TUif+gGly
        w7/aSCT5kdHEpyTWF+yPeRZ55m5BvfQecMcC8bFoPUynaGtAJZtIMtKS7UsOd6QkEG6yT9G/rAH94
        2pQyY9pY3gU1H6CZDkcizo20lHCf2T2GHo214i+tGZhSaor03Bxgeymq0Gh6F2MW5WFNVH/uX9Pe/
        JI6ws/pVCjeZMtGGE5lZbkA04xF2z3CwWxRE7JA6va8Q4mJFe0bIfDFtY5ac6MpcB1PCfBfOkoKRQ
        D1roa9Wgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iUDmR-0007Ue-SE; Mon, 11 Nov 2019 17:47:11 +0000
Date:   Mon, 11 Nov 2019 09:47:11 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 01/17] xfs: Remove all strlen in all xfs_attr_*
 functions for attr names.
Message-ID: <20191111174711.GA28708@infradead.org>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-2-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
