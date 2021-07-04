Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01643BAC28
	for <lists+linux-xfs@lfdr.de>; Sun,  4 Jul 2021 10:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhGDI6Q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 4 Jul 2021 04:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGDI6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jul 2021 04:58:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1636C061762
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jul 2021 01:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=RjfIU/gLR06Fs50RjC8Cm6r5jm
        pKBS/wDnLg21Re5218Wo4qlLlaM4/MAgKiZwPM8thAVKQNurWqhjPPh9zsyFW3rz5y6bqslhz69Bt
        n5QV0z7KCEqwJtP57KkQOgn4eo/W47gFWKmRR+4xMDnkGKu4qU3+ao8ETRj/aNybEr3869XXrI9i9
        V3lfqNbuaubxjQqeNp7PHgpVLbQeoAKD8NGJSOGHTVfWyHM5HMuy5fV7z/j1ohV/jd04QT5EOx9oC
        cYLwthSl344LYq5T0klk9gxw3DThz1AEdeI4HyjOq4vipIfW71TSqWWUIKoyQRnCgkeuN2R7Y6L/m
        XoauarCg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzxtH-009BRu-HL; Sun, 04 Jul 2021 08:54:29 +0000
Date:   Sun, 4 Jul 2021 09:54:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 2/2] mkfs: validate rt extent size hint when rtinherit is
 set
Message-ID: <YOF3N3IAZ/MfBQXt@infradead.org>
References: <162528106460.36302.18265535074182102487.stgit@locust>
 <162528107571.36302.10688550571764503068.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162528107571.36302.10688550571764503068.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
