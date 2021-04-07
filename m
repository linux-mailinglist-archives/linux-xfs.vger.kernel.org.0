Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D81356424
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Apr 2021 08:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348936AbhDGGgx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Apr 2021 02:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348922AbhDGGgu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 02:36:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BFBC06174A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 23:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=WseIG94VkXA+ND705SIGu0g3LI
        Gjte0RFUK3UkGH7z4p5TQa5uiXgnka0F12QKmtGHYDUWnmHdamVszijzN5wSqcXvTVI7eRJnu57g8
        lUpRfN7hfBFqCTVLhPJ167AU6H4hqi9yiMWRE2xzULG1Aqk4S9CgfWQE6u7ecYPHg9q0nzVv+uaHR
        PGAtOGGjVYnNnJQZBni7LEJcarh1b41ytDeis2Ll5LmwRivEulGwlnW1zXI0XieVSU55oLL20QKZ1
        Dch0LGSDc2bUUj4m0nHD8Dw1xwFEPhm5SgbbfOMZHR2MfaKXw/tbYLbpNsOrbSTMQIYZvD3Owbaaj
        syLNoDuQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lU1nN-00E1Wb-L9; Wed, 07 Apr 2021 06:36:20 +0000
Date:   Wed, 7 Apr 2021 07:36:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: drop unused ioend private merge and setfilesize
 code
Message-ID: <20210407063609.GD3339217@infradead.org>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405145903.629152-4-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
