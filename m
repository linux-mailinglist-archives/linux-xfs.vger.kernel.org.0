Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E965254DF
	for <lists+linux-xfs@lfdr.de>; Thu, 12 May 2022 20:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354290AbiELScD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 May 2022 14:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351879AbiELScC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 14:32:02 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96F1A63523
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 11:32:01 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 61C3F335038;
        Thu, 12 May 2022 13:31:59 -0500 (CDT)
Message-ID: <966e0de6-f7de-d3d5-4599-7f06b5f44de4@sandeen.net>
Date:   Thu, 12 May 2022 13:31:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176663972.246897.5479033385952013770.stgit@magnolia>
 <20220510213042.GF27195@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 3/2] xfs: note the removal of XFS_IOC_FSSETDM in the
 documentation
In-Reply-To: <20220510213042.GF27195@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/10/22 4:30 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update the documentation to note the removal of this ioctl>
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>


