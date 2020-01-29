Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589FE14D018
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jan 2020 19:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgA2SGc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jan 2020 13:06:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57988 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgA2SGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 13:06:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Rl6TMP4hQRWbXnvZvFBhNq6O4HULbNXoPj42ZxR/4Ws=; b=Co3OZz8zVi6wPjACpU4LPPEEj
        GxI3zj1f/NJ6Nc8FrxoOJfkmBTfpF5ptDIWZwA54KaFDCs2J1MA+sK0E/+MLV0gdY0pEYAB9d1GOp
        OI6SYcB/iwKAzoJcrGCQvPHjiFFnWifSWLWGOuv73OP6BifEz4nLE13bmxRLQhcW9U8mNukCRZiy7
        7iA7Jv7btCQxwnSS20TTwq5zr7rLfhVLM8YCe74FL1s+20QZCD8vvft/bRtQpG30f8zD1cuDFS7VJ
        6+V7F8LA33fk7TB1UfGmS/yRmDMAtIECuL1JWWc7d1iei2kj1hlAXwP0YwSrH1yNtEEVdvh7s4mRZ
        htDo6Mxdg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwrjU-0005Az-ES; Wed, 29 Jan 2020 18:06:32 +0000
Date:   Wed, 29 Jan 2020 10:06:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] xfsprogs: do not redeclare globals provided by
 libraries
Message-ID: <20200129180632.GB14855@infradead.org>
References: <0892b951-ac99-9f84-9c65-421798daa547@sandeen.net>
 <a2b9920e-8f65-31d8-8809-a862213117df@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2b9920e-8f65-31d8-8809-a862213117df@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

And with unmangled whitespaces it looks even better :)

Reviewed-by: Christoph Hellwig <hch@lst.de>
