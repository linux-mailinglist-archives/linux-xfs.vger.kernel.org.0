Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D3E1E893
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 08:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbfEOGvW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 02:51:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55744 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOGvW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LtpiYrd5FPLhwAGJ5tV7w2YoGbBy+LdlzxY1mUAf7w8=; b=Gf24ci/QfTAeZEPzvW4jbYivg
        c+gGh1cbstLSwxQsrx9vlpaL5cD2Ooc1CN3dSYagGclg14enzDX+jbXO7BxUbCmIw7jEuuJoMpFTT
        NriB5LIeVTIUZCrcqerXFl4N4i7IPbxsYSq3EfBaCP3qr4/bW3jOIFQVXDXTW2vmErPc5ECGIOn6W
        +q94xAWTLraPgMUzzfifam1NYzxAKwZFdBJdkrsLnOTt9ednhVg9iK2BV8/OkAOEiQtwDBRjo52CE
        RGJ5PcBHfJGtdcrpGxmkOX2ipT4afmjcZWctDDAhpLx3QU89sVk3o5XsAa36xJVLsa+Pbgs7xmSvr
        hUgSAOIqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQnl3-0000Qu-Mu; Wed, 15 May 2019 06:51:21 +0000
Date:   Tue, 14 May 2019 23:51:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] libxfs: remove unused cruft
Message-ID: <20190515065121.GC29211@infradead.org>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-4-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557519510-10602-4-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 03:18:22PM -0500, Eric Sandeen wrote:
> Remove many unused #defines and functions.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
