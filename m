Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0645056D484
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Jul 2022 08:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiGKGM1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Jul 2022 02:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGKGM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 02:12:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D876BCB2
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 23:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=REHl2hDWwPyK+unkHRBXkA2JPrlfcP0OH5RdxxJJDn8=; b=y4bo40mPAEf2Eug/bp+d1sj0Bf
        wCklue753LBl1OlsIWxqchSR3yfbMefnAcPAnlhGGKP464Nc9DmOhkTGR/Jgzko6zxBdrUH0hmX9R
        3x0IiY5vlwR7xwrbb1y0PoFUs2BfuTJn2Xc9r9pw703itMzOPDvAPPGCCecWkT5OW6fYQHXIoBYji
        LhqvVOsuvj9+7S8CJ2PPn+m4Uit7tzl+oDWSEMaFf6LOGs1s+o5fBgaWqzq7PuOEPxZBrmoLdcxdv
        DpKjAhfLgNBQcYYty6TmWgK+XkukEkobe1OV5ZmCpMGMPe3o4MV4VRq+0buUX58PDYrH2pY32oSF6
        MI8uP/dA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAmef-00GLEV-TL; Mon, 11 Jul 2022 06:12:25 +0000
Date:   Sun, 10 Jul 2022 23:12:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: move and xfs_trans_committed_bulk
Message-ID: <Ysu/SU6RNhJcdU4o@infradead.org>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708015558.1134330-8-david@fromorbit.com>
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

The subjet does not parse.  The and should be dropped at very least.
