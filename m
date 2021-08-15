Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757B23EC851
	for <lists+linux-xfs@lfdr.de>; Sun, 15 Aug 2021 11:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237193AbhHOJVZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 15 Aug 2021 05:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbhHOJVV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 05:21:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4FEC0617AD
        for <linux-xfs@vger.kernel.org>; Sun, 15 Aug 2021 02:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=NF0huCKUF41z4A7OQum197uhUs
        DpKG+AfVoNouxyNw+xNyen+eHUtq9s8pgpR/8sH5m3G0lS3vNILJEXa9b0K4qTAjm8UwwmHnZePC+
        Hmsbw2iSHCvmhF+U4Xx0DU96jIQVpHviFAK8prsHhk9e4e6hInbQEF5sfkIPu+wjM+r27b3dR74Qn
        Y+hbhc2znFCoVYdhy+LGeYz2A7m5y1gB/J4gTU2C/YnDehJ7sWjmM69cDN7piyN6Nf6JAlDWUWRWv
        TxQpTnkVY0k7kIG237yugKnwxqC3+JEglpePexv1wqR5pG1/NXSb2jwl6fgWosqmjVy76zKeuM/Ks
        if4D0kJw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFCId-00HaDB-8y; Sun, 15 Aug 2021 09:19:54 +0000
Date:   Sun, 15 Aug 2021 10:19:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: make the pointer passed to btree set_root
 functions const
Message-ID: <YRjcGxDB7WnlKEBs@infradead.org>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
 <162881112205.1695493.15576454755917300007.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162881112205.1695493.15576454755917300007.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
