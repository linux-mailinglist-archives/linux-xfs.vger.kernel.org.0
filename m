Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7E233C5A7
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Mar 2021 19:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhCOS3M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Mar 2021 14:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbhCOS3L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 14:29:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44F5C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 11:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=jz2QZljqKrDspjYXl0bB9Q7IkB
        jyOROis9HWvk75LK6utC3i8AhaUhww4qmYylglyjMiTKnt/Mf5BvvXC5nl/x7+8CbqiXP9zCXsZ9B
        srvG1/1mJaaxAGwyxnRndqYxM91MfEqUDC7MXia78f2/OqtBhQKR6qrLIdnliak956tNnI0vuwYyC
        PtcC8rQifRL8b9NPVLu/C7MiJpPY2SnCLH7cbN1rpqtluo41V1agJxIWxag83BAAewnzyGV9Jw0Hp
        oy+iEVGlKCvlDwnWjznjnsA+W07OizDLuCogSREgdUAq61tSlB7bmI0CGT/Xo33qaEAcurlP+yKgW
        vYxYtnVg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLrxk-000aw6-P9; Mon, 15 Mar 2021 18:29:09 +0000
Date:   Mon, 15 Mar 2021 18:29:08 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: don't reclaim dquots with incore reservations
Message-ID: <20210315182908.GA140421@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543195719.1947934.8218545606940173264.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543195719.1947934.8218545606940173264.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
