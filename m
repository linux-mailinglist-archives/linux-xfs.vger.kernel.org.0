Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F7D1D6673
	for <lists+linux-xfs@lfdr.de>; Sun, 17 May 2020 09:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgEQHeS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 17 May 2020 03:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgEQHeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 May 2020 03:34:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E37C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 17 May 2020 00:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=s1ugIAVPKuDGLgN/xbDm8d+nXA
        GyUurj4xot9bEKLcmLHdhDVMfgnSOMVTQvSoW1NrwqFbMOLFp0hGgdWBG6bxm0fnQkl47quBon+ZT
        lEw5IhDQKkSIvO5mz9Vz8phMLfMmcqbbLCGsC2p3oBRosNaxmawsweiO4Qms4r+JOL1y4OE/zL7C4
        io6NXOVulypXRJ8MG5pITBdnqoedzBSwZnxdzKEGb2UYIQZ0W+47n/ltggESSJ9y3uNJprN11ixkb
        67K8h17k1scAb4TSwvx5TrfBJ/tbFaXJn3tSpVdMMwyM1vq/HZIVDvHSQqB2D9kxCzv9EZBHWibRz
        qoN2W91w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaDoL-0002vj-M1; Sun, 17 May 2020 07:34:13 +0000
Date:   Sun, 17 May 2020 00:34:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: don't fail verifier on empty attr3 leaf block
Message-ID: <20200517073413.GA32627@infradead.org>
References: <20200515160648.56487-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515160648.56487-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
