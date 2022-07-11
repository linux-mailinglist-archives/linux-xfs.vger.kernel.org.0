Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C143656D4FF
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Jul 2022 08:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiGKGyV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Jul 2022 02:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGKGyV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 02:54:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3A313F68
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 23:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NKNgD249L+ZVTKH0IyWLf983y8GYjqiAL3GejuYcjLY=; b=dw0kcpApXEn9bZ6WL+ta6jz/pG
        axeE9zB+v+fw1JAaIwuAkISr/7007t6Sq2CGO3cPE3E7QChTa1hiurZfm72petBIb75WgRP5MRoLk
        9O8NIYXQd8rT4pLtYD1g8+X5HTj8Yj+WTo4AzaNEJyr6dJk1c8PiL0UYcZ2CccsPmxFHXS4IzhAHN
        5qIYq/54kYPdGOL5IN/JpxaxWnbd+mMegwEhWtXb76U2AQKJX3wWib61N9j7R1UL5/+gaXLoTTI4Z
        WuuSE6KmHLnqo1ldIfwESpVaIDGAdFVQ3IKxfR3Gj7y/S7pS1RVAtD1InAC8NWeRCmzaDXMtvw0b0
        wBNLOABA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAnJE-00GY4u-0I; Mon, 11 Jul 2022 06:54:20 +0000
Date:   Sun, 10 Jul 2022 23:54:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: track log space pinned by the AIL
Message-ID: <YsvJG8hnX/L6YMq8@infradead.org>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708015558.1134330-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hmm.  How does a patch to just update the new field, but not actually
use it make much sense?
