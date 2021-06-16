Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7B73A94D2
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Jun 2021 10:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhFPIQJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Jun 2021 04:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbhFPIQH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 04:16:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D95C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 01:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=BYHL4slCpkib23pEIeRpksYAph
        bEQRgYKzKt0Yu81TbaDgOqc5lh27JdQjfcrVcJNPx7Jn5ts4eYuEcu9KCH3OPS1uaglFu8wK65lSl
        V/t9j/dW3rc+OZZ1IsVGe9qqr8+K9ByV1dDqoFnNoaYTsfGLgs64Vw2kKVTtkEqEaA1OXSDkMLn5D
        Sp6gmfJKbmsMAp1ozcJEilFJBgOC2uesJD3zDNerJ0EzyxzT2Nj+Snj2TAIAXxQtMzEZagVnSdFZA
        7p5EpUq1k9w/PNClW3MVPTq7n2MfNkN8EyOjjlXwTh3zU5r+HpSk67wnrmtRhSulvvC4K2ennzHIo
        2+rxQHfg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltQg6-007nDY-91; Wed, 16 Jun 2021 08:13:42 +0000
Date:   Wed, 16 Jun 2021 09:13:38 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org, bfoster@redhat.com
Subject: Re: [PATCH 01/16] xfs: refactor the inode recycling code
Message-ID: <YMmysh+WafvmJwwm@infradead.org>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360480240.1530792.10821283161255096063.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162360480240.1530792.10821283161255096063.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
