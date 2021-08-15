Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A45A3EC836
	for <lists+linux-xfs@lfdr.de>; Sun, 15 Aug 2021 11:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhHOJBT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 15 Aug 2021 05:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhHOJBT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 05:01:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74824C061764
        for <linux-xfs@vger.kernel.org>; Sun, 15 Aug 2021 02:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=mnulZBYdBff2+BD8VM8vzL2eHQ
        IduRd+MehjRNb5p11Xy48Evg0xTkwaf08WAG27mB5qxdfP5YJj2DBCAGne7lEekPknK8rbL1fLxTO
        YmfTs2L+r9Mtw52G+hzepcmSY03N5yTPgn4gQY1+RdIwUpfn1ivoIxo32WRll6bSUjp9zqiUYblgc
        771xFmmxG+7kMMpSKDeimtMQYNy8i0+ui8VEUT2Jq8lOHk2UO7nug8/av4Nyvvud4xNgoCC+CPLwQ
        nxgsFKv2phM9Z8hMuWkaWJO0RjajjPMVo2w87r6tePWgp9u7vGcwePM5G64QDFuQNtyJnBZk77ZlE
        H27R8bjA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFC0D-00HZSz-Sb; Sun, 15 Aug 2021 09:00:35 +0000
Date:   Sun, 15 Aug 2021 10:00:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: make the key parameters to all btree query
 range functions const
Message-ID: <YRjXpQogeGycZrwV@infradead.org>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
 <162881109443.1695493.6458037403329160173.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162881109443.1695493.6458037403329160173.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
