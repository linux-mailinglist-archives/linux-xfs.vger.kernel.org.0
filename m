Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E967525BDE5
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Sep 2020 10:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgICIxT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Sep 2020 04:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgICIxS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 04:53:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CE8C061244
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 01:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=M56vy+Qo00hJiaufup9wr9Xlb1
        EBi+6RDmcm8u8q09nBSlQ2L0VkplEfF3kDPXoIh5kBGTSEfu9Ogbo02x1F9gEIl16sPFYxaNTlF/W
        fRoSl/Hdwd+/LigmguQU6zkujxkDPzpz2gn1NUSNqdi+DDaEWdlUMj3dZWeB25j9FpdpjRgXNoFwm
        6LHXCTBewfnWNgssa7hphpW3zBeFR9zXqNFJB1SMGHgO1xXdi0rQH//GsI4qVEgnlr7eNPjfMlKCm
        ylnGVOwaSZ37BUSUIZ5sQAPElTHxj92QHbe5o+Xc8z5FgsHykkASYf+6fJnSer13vl9mXSViJQ3SY
        piVoB1vg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDkzd-0002oD-50; Thu, 03 Sep 2020 08:53:17 +0000
Date:   Thu, 3 Sep 2020 09:53:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 2/4] xfs: Remove typedef xfs_attr_shortform_t
Message-ID: <20200903085317.GB10584@infradead.org>
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902144059.284726-3-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
