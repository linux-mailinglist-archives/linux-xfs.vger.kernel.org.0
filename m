Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F94F261E7F
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Sep 2020 21:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbgIHTw1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Sep 2020 15:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730726AbgIHPtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 11:49:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC29C004599
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 08:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=INVCgSqkj+MfaOK2YCMvOQJLCK
        G3i8bm/7HhflVHyfLqbftT/HkKnoitOqJ3J0iFqh8bANLW8HZw3qWrBA+vOgkoEtPGejwzFXJUwrF
        i6vRCwMtDp7sr06iI24dRu2/F8FdaeRTt6r8V/hwIJpTl4DPE9jzNEZ7O0I42zo51TtAcXrDMMrXf
        ceXmdDgFzU2sPOsgG+3g/DyvcO8hvUgUH/1NI1rYZrXzLvovT/HGeVTgZwe4N5Xc66Gbq7J1mtqxD
        Ga0I+9ELfcKxrHrISsVDSLs8LM8efHZMe4bR0nWT9vgB+HkUP8//75qY/KsavH3X6PlfXS1bRE49b
        vMy4xm8A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFfBn-0003j7-4O; Tue, 08 Sep 2020 15:05:44 +0000
Date:   Tue, 8 Sep 2020 16:05:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: force the log after remapping a synchronous-writes
 file
Message-ID: <20200908150543.GQ6039@infradead.org>
References: <20200904031100.GZ6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904031100.GZ6096@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
