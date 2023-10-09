Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7189B7BD8BA
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Oct 2023 12:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345759AbjJIKgL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 9 Oct 2023 06:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345825AbjJIKgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 06:36:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBA79F
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 03:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=o2Oa9UF0U+jmLocajNrKBO8PZq
        /8HkgOCpMujdFBW7agTzyeL4k5YQ+JxTSmeoXcO7qgZT6T7OORkYwQ388zA1CzTBG+zocsR0nxORO
        lEkj5Smk1Lki85YQ4wCpn4PeCeMgiAun/YV5wQYcBgX3+rY+9cPwI6hzS/JGKr1yud61nQXxD1Pih
        J7VKNfsPwvswBBJ1XRCoT1BGZ/0DWE0vGjdAw2/vupIngam6SCGp07+XuER8IaMYcrNLlSrLsDp6y
        2GVqi1eFqUvluu2yaFFSDBExIgwlIuMlzuqqmOBMAShbzayc1qSvAXkkILvckONcIAbgUiE6FEgZR
        UsjzNXxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpncN-00AFDL-3B;
        Mon, 09 Oct 2023 10:36:07 +0000
Date:   Mon, 9 Oct 2023 03:36:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        kernel-team@fb.com, Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH v2 4/6] xfs: limit maxlen based on available space in
 xfs_rtallocate_extent_near()
Message-ID: <ZSPXlxza7v7MWtym@infradead.org>
References: <cover.1693950248.git.osandov@osandov.com>
 <913fd7a759f56ba07a6b7eaa3894d14842167ed8.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <913fd7a759f56ba07a6b7eaa3894d14842167ed8.1693950248.git.osandov@osandov.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
