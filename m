Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70E2726148
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Jun 2023 15:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbjFGNbI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Jun 2023 09:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240221AbjFGNbI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 09:31:08 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B291732
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 06:31:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 56C0F6732D; Wed,  7 Jun 2023 15:30:59 +0200 (CEST)
Date:   Wed, 7 Jun 2023 15:30:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Weifeng Su <suweifeng1@huawei.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de,
        sandeen@sandeen.net, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com
Subject: Re: [PATCH] libxcmd: add return value check for dynamic memory
 function
Message-ID: <20230607133059.GA20840@lst.de>
References: <20230607093018.61752-1-suweifeng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607093018.61752-1-suweifeng1@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
