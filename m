Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F30E987C5
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Aug 2019 01:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbfHUXUQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Aug 2019 19:20:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbfHUXUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 19:20:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mNZydWMkgx1xyvi+vVlLbvm6VpwE/4DMZb6IIBHnEJQ=; b=OE3ZU+9hXhHJNSCjY7/PIL3hD
        8DshyO2a8WQNfxTcQXafIUo+NsXy+JDMq8StY3l50SQQUyXN+vafWthfsoXeKwZB2XTUzx974Ueu2
        PI6UgZJmt74A1ejZzRvsT0KK948FITDxQbakJL03OAVACVP6dKciaE0UuUFxTTFLN66s+WHsQTWyl
        fzaNvVtBlDqu3HAlf0DwnZF8S8wdGFd0Syt/fy5g19e3xtF2x0NyYbkwSrLAIDH2xQAdO4nnfYII7
        Oj7QXZ7KI45MJRmJQ6Z22LqTIhCVaKAJAjkfkMuH1Fl4ayalOwyGa/EJn1Xc4XBPJWVMPmpKsFjxd
        6mJYN+BEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0Ztn-0008LX-RE; Wed, 21 Aug 2019 23:20:15 +0000
Date:   Wed, 21 Aug 2019 16:20:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add kmem allocation trace points
Message-ID: <20190821232015.GA24904@infradead.org>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821083820.11725-2-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good, especialy with the size tweak suggest by Brian:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I'd just split the AG constant move into a separate patch to better
document it, though.
