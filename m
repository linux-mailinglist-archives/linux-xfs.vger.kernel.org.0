Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098E97F24DA
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Nov 2023 05:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjKUEfE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 Nov 2023 23:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjKUEfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 23:35:02 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567C9CF
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 20:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=l/uylQuxFlmh0fsQ0f6hRCscp7
        xW1fLGi9gyq5ru3uW0CkKSQQl9XGjFhl7lj+Xnaf2y3/PJ5G2gUQFD0F3ja3isq9LnCBgtbewUQ/2
        obaIJEBxARrKOKX4jXPIOLrJ9vCUWbbnQPpdBCkNpKGhIdhjzkPw/cdWN4kaLn+cIba7dRnu3lkvU
        qcO9Sp1pOmUkGjvU7Wd9tVihaxDHQHArbTj7dw8lZDnI28lHY/rKVjVgcBZty5v83S6DPJnd4WMAn
        A54PyGdTh+xGYFT/mwaIVkQyODLPbbvZOOGQe/rTVdoX7ECclLItAgr3x9fECqvKYAmx5GSLDdhux
        LSHcOdQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r5ITS-00FbBb-27;
        Tue, 21 Nov 2023 04:34:58 +0000
Date:   Mon, 20 Nov 2023 20:34:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, chandanbabu@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: dquot recovery does not validate the recovered
 dquot
Message-ID: <ZVwzcvz7q8bHJO42@infradead.org>
References: <170050509316.475996.582959032103929936.stgit@frogsfrogsfrogs>
 <170050510455.475996.9499832219704912265.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170050510455.475996.9499832219704912265.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
