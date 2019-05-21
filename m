Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490CC24A73
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 10:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfEUIdc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 04:33:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfEUIdc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 04:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=mpHEr3PwPhf+gKO5jCXpqAG3i
        4/bWfKPZIcsMa+wfLSrcT7TblWFQKBGAVjOABYJ49CRIIYSkKiSQItNGW9EnhtC06wChLMQrbPvEF
        lVq5aApV6mRP4yS75Z/rADoRY98i7WkGqQPrVj1fzGgtV2yHv88wU0gCu10aSNnOcM0cig1CCjsEd
        dAUoB+V0c2AKIBhxcj3TwQ2/3j63Ii97TGN8zigH4NGVfkwhM2M2x+LY6+NXLGlMFmgAH7DNfFEPz
        ZzQ+WMFFkGRjqyc7/hQCgkhMkGVDGxcteSM8ZcH27iW9zLLLGxUGME/vYQiIh3rC7MuBbIcUQOl0U
        1I2jZYycA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT0DE-0000S4-67; Tue, 21 May 2019 08:33:32 +0000
Date:   Tue, 21 May 2019 01:33:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] libxfs: rename bli_format to avoid confusion with
 bli_formats
Message-ID: <20190521083332.GB533@infradead.org>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
 <1558410427-1837-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558410427-1837-3-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
