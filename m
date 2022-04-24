Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5229850CFE1
	for <lists+linux-xfs@lfdr.de>; Sun, 24 Apr 2022 07:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbiDXFdx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 24 Apr 2022 01:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238299AbiDXFdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:33:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DEF5A5B7
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hl9bi/1hj0cycIMwS7Rwcf9zRJ
        5OE/I+TO4EI8Vw9jOsTPCw81Sy7OIik1hjfnbRNHIVdbIfdJ/SZ+Z21z/Pic8e2LVl0vo7Bpb+qsG
        kpocLaC2pE9ybmo4VJt8TPtqKXvtW7OHZE/vVNAjya8FjOnobCsj9Bob5SwAkqsPqwvodvR4Qj30E
        mK3homhqG9ZxJUri3t6ld/1PfN4QhNnSMdzHweLqUCWhPK59d6cTnsvKvg9JRD09vmngUvUK9rsVc
        F71Ycx86ty0H1ufPdLeUNUBVE1MS5MwsxYKOa7SsiIcI2q3Q/9AQUxzxOK9VrRHL2SAYnCxjvQ+I3
        zSwzhnrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niUpV-005qIK-B1; Sun, 24 Apr 2022 05:30:41 +0000
Date:   Sat, 23 Apr 2022 22:30:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: simplify the local variables assignment
Message-ID: <YmTggYMYgE+eThJW@infradead.org>
References: <1650382606-22553-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650382606-22553-1-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
