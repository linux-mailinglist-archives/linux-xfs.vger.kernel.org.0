Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF43722CAD
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Jun 2023 18:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbjFEQcW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Jun 2023 12:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjFEQcF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 12:32:05 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D34A710DB
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 09:31:29 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPS id ADDFA48C71A;
        Mon,  5 Jun 2023 11:30:59 -0500 (CDT)
Message-ID: <bd675e5c-20ac-c23f-8106-5181032e72d7@sandeen.net>
Date:   Mon, 5 Jun 2023 11:30:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH 1/5] libxfs: test the ascii case-insensitive hash
To:     "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
References: <168597938725.1226098.18077307069307502725.stgit@frogsfrogsfrogs>
 <168597939284.1226098.4252229601603573827.stgit@frogsfrogsfrogs>
Content-Language: en-US
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <168597939284.1226098.4252229601603573827.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/5/23 10:36 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've made kernel and userspace use the same tolower code for
> computing directory index hashes, add that to the selftest code.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

This looks fine to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
