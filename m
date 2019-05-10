Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB451A244
	for <lists+linux-xfs@lfdr.de>; Fri, 10 May 2019 19:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfEJRYq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 May 2019 13:24:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59318 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfEJRYq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 May 2019 13:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qL4vo3lrH3WvJYL/lAWmhIIz6/vPsrroMLB1kHg9Op8=; b=HbBpSasADLKGRfDxg/JbBs/31
        ZugeorLbZlcJbo6w3IBeJ9Mc0F1wTPFNSM4HizuwzE9zNozUVp14I3/CfQpH2j9T0emovrFvu+lpr
        5PRGDHXyHrrIBJSaomFFjyis4q3tmJI6EJnRyhfVAEjCazBK/yj+uAjVTxl+h8tE4J0H235BRUsBx
        r+ECKDjA3GrsHf3F4LKhMHID63KCWc/pZx2JzX4lpDdKiqbWwiRKC3X7ViTcRpEFE2udvnhAHHNMz
        OVgYIBdHVSVxdn4xzN9IYgnYRM+5rKUU/TBYSUZP6PJLKb/wQznqNsRr2Iercf59L7K0M3dFr2yCF
        QTQcy1SmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hP9GI-0005BJ-5P; Fri, 10 May 2019 17:24:46 +0000
Date:   Fri, 10 May 2019 10:24:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: refactor small allocation helper to skip cntbt
 attempt
Message-ID: <20190510172446.GA18992@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165839.44329-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This looks pretty sensible to me.  What confuses me a bit is that
the patch is much more (good!) refactoring than the actual change.

If you have to respin it maybe split it up, making the actual
behavior change even more obvious.

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
