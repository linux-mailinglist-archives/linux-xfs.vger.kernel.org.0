Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FE81E0F7E
	for <lists+linux-xfs@lfdr.de>; Mon, 25 May 2020 15:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390794AbgEYN2f (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 May 2020 09:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388737AbgEYN2e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 May 2020 09:28:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAA3C061A0E
        for <linux-xfs@vger.kernel.org>; Mon, 25 May 2020 06:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Hr+rNAb+ov2/KvpbJ4DIv1xBWE
        RQrfbdzRXTAp+zRPR28rm8c359oTtVpxVBzlmTbzRiucQol0ca4wDNJGNJAz+R1uy8sXZWnjj+ASq
        CWWXiK1/RSrljQ+hgxdPgYRWtyKdIzLzXy2U4THnpVt1MxC0mf9mZxYgT9U4baIWCFw35CwRJ/3Em
        JdeYUKQmKF9Z7yjOsDK/LONaqj3mHFpZ4hpTFCMqBZA23nJvnShLAnXGKx4De73kQV1Kty3D2oqvi
        V82c+GGfguvOyqfPL483kM2s9aNKFQxiQK28couDUxXsE+sInXFnOnfxa3H5jc5MmmFxyJQPs97fW
        Ic3z/Mhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdD9e-0008B6-CY; Mon, 25 May 2020 13:28:34 +0000
Date:   Mon, 25 May 2020 06:28:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Subject: Re: [PATCH v2 2/4] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200525132834.GA13530@infradead.org>
References: <159025257178.493629.12621189512718182426.stgit@magnolia>
 <159025258515.493629.3176219395358340970.stgit@magnolia>
 <20200524171612.GG8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524171612.GG8230@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
