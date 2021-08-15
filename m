Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F763EC840
	for <lists+linux-xfs@lfdr.de>; Sun, 15 Aug 2021 11:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhHOJL7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 15 Aug 2021 05:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhHOJLy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 05:11:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696E4C061764
        for <linux-xfs@vger.kernel.org>; Sun, 15 Aug 2021 02:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ZIsi29vyG3DVO3onNTXk/BSnG/
        DDhNp/4LS/4VWMbT2YpRriE7oSYj9jv5Jjr1C+hI0pywOufAf82/Pr41iNP9hWlaR8gB0iAbmG8+u
        tChdiEu0JMurF8KkUMlX2DPdfgaJow/btBbVZU/oK8h3jyZEDGdCy1EXNYE0z1Qkv78qPwjO01H6w
        X8cqDKu6U1xoPc9TSlWBCWG7HVEAQWVPjyLj9FFYlF392mp4jqHCnCX0px0p9X+jib33NERgU5mrr
        MsATpBJMJIb7GUBDTsk6Wh/LoGzYyWZENkAPffpfnq4UIgsQH/bZOmawe976GIcejCg1kfY3g8Ku8
        q/BlSmVA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFCAF-00HZrA-FS; Sun, 15 Aug 2021 09:10:55 +0000
Date:   Sun, 15 Aug 2021 10:10:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: mark the record passed into btree init_key
 functions as const
Message-ID: <YRjaE09d29bN7i5f@infradead.org>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
 <162881110548.1695493.18089688856522736997.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162881110548.1695493.18089688856522736997.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
