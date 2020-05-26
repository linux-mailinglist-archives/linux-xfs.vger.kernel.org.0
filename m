Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF821DCA36
	for <lists+linux-xfs@lfdr.de>; Thu, 21 May 2020 11:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgEUJgU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 21 May 2020 05:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbgEUJgU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 05:36:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9F1C061A0E
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 02:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=s9+PrEQdvO0Od5tLEcWAgc+Y4G
        XoaLmcIiEG46VtPDAQe/QeM9HSRWeQbVR232t2r4V8zxnYAt2FHjry1thEKTUl5IsTV7eR2FdkBdm
        l/nKt+sOv84tsbfzi1jjOOEcFSfV2ycFiAesDTwEGMRbPUawi4I3oxtCbYnCMJx6fGdtgnQXShG1S
        V9QP2fw9bBfHttE3LkZZeR2Y1iU0M/3xvzC7HoQSc6uIoxLEaxu+GeN8Fo3Lqn6vCOX7cdtEp3D3X
        TL0k4gjVQJA2pYlg4bKJB0wFw8NEIuhrXOj3zytWR4vXnuaSuyXctFpq9I3M7kqebly7FUtu3xpDY
        Gm+ZlRhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbhci-0002no-B3; Thu, 21 May 2020 09:36:20 +0000
Date:   Thu, 21 May 2020 02:36:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: per-type quota timers and warn limits
Message-ID: <20200521093620.GB28324@infradead.org>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
 <1590028518-6043-7-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590028518-6043-7-git-send-email-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
